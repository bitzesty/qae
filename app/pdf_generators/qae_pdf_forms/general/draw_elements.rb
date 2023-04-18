# -*- coding: utf-8 -*-
require 'open-uri'

module QaePdfForms::General::DrawElements
  DEFAULT_OFFSET = 110.mm
  IMAGES_PATH = "#{Rails.root}/app/assets/images/".freeze
  LOGO_ICON = "logo-pdf.png".freeze
  ATTACHMENT_ICON = "icon-attachment.png".freeze
  ALERT_ICON = "icon-important-print.png".freeze
  ALERT_BIG_ICON = "icon-important-big-print.png".freeze

  def attachment_path(attachment_file, link=false)
    if Rails.env.production?
      attachment_file.url
    elsif link
      "#{current_host}#{attachment_file.url}"
    else
      "#{Rails.root}/public#{attachment_file.url}"
    end
  end

  def attachment_icon(attachment_file)
    case attachment_file.file.extension.to_s
    when *FileUploader::POSSIBLE_IMG_EXTENSIONS
      attachment_path(attachment_file)
    else
      "#{IMAGES_PATH}#{ATTACHMENT_ICON}"
    end
  end

  def path_to_attachment_file(attachment_file, link=false)
    file = attachment_icon(attachment_file)

    if Rails.env.production?
      open(file)
    else
      file
    end
  end

  def draw_link_with_file_attachment(attachment, description)
    default_bottom_margin

    # FIXME: https://app.getsentry.com/bit-zesty-client-apps/qae/issues/101873287/
    # Prawn::Errors::UnsupportedImageType
    # PNG uses unsupported interlace method
    # Uncomment me once you solve issue with wrong file formats
    #
    # image path_to_attachment_file(attachment.file),
    #       fit: [35, 35],
    #       align: :left

    # move_up 17

    base_link_sceleton(
      attachment_path(attachment.file, true),
      attachment.original_filename.truncate(60),
      description ? description : nil)

    move_down 5.mm
  end

  def draw_link(v)
    default_bottom_margin
    base_link_sceleton(
      v["link"],
      v["link"],
      v["description"] ? v["description"] : v["link"],
      {})
  end

  def base_link_sceleton(url, filename, description=nil, ops = {})
    indent (ops[:description_left_margin] || 0) do
      formatted_text [{
                        text: filename,
                        link: url,
                        styles: [:underline]
                      }]

      move_down 3.mm

      if description.present?
        text description,
             color: FormPdf::DEFAULT_ANSWER_COLOR
      end
    end
  end

  def main_header
    render_logo
    move_down 8.mm
    indent 32.mm do
      render_urn if form_answer.urn.present? && pdf_blank_mode.blank?
      render_award_information
      render_company_name unless pdf_blank_mode.present?
    end

    if !form_answer.urn.present? || pdf_blank_mode
      move_down 6.mm
      render_intro_text
      move_down 2.mm
      render_guidance_block
      move_down 2.mm
    end
    move_down 7.mm
  end

  def render_submission_deadline_block(indent_value=0)
    title = Settings.submission_deadline_title

    if title.present?
      indent indent_value.mm do
        render_text(title, style: :bold)
      end
    end
  end

  def render_guidance_block
    render_text("Before you begin:", size: 16, style: :bold)

    render_text("The application process:", size: 14, style: :bold)

    bullet = "\u2000\u2000\u2000\u2022"
    deadline = Settings.current_submission_deadline.trigger_at
    deadline = deadline.try(:strftime, "%d %b %Y at %H:%M%P") || "-"

    block_1 = %(1. Complete the online eligibility questionnaire before you start preparing the answers
      #{bullet} This is to ensure that your organisation meets the key eligibility criteria for an award.
      #{bullet} It will take about 10 minutes to complete.
    2. Complete the online form
      #{bullet} You can use the PDF version of the application form for planning purposes only.
      #{bullet} You <b>must</b> complete the <b>online form</b>.
      #{bullet} The online form can be completed over a number of days.
      #{bullet} You can save and return to the online form at any point.
    3. Submit your application
      #{bullet} The deadline for submissions is <b>#{deadline}</b>.
      #{bullet}  You can still edit submitted applications up to this date.)

    render_text(block_1)

    render_text("Guidance on answering questions:", size: 14, style: :bold)

    section = form_answer.development? ? "Section C requires" : "Sections C and E require"

    block_2 = %(#{bullet} Read through all the questions carefully before starting to answer so that you can plan your responses and avoid repetition.
      #{bullet} Plan enough time to prepare your responses, allowing time for refinement to ensure high-calibre submission before the deadline. Previous applicants reported taking at least 20 hours to complete the form, and some took 50 hours or more.
      #{bullet} #{section} longer text responses - start planning these as soon as you can.
      #{bullet} You may want to spread your application over several weeks to allow time for collecting external evidence.
      #{bullet} You may need to get your accountant to help with section D – allow sufficient time for that.
      #{bullet} All questions are mandatory unless specified otherwise, but if the question is not applicable to your organisation, you can state so, explaining why it is not applicable.
      #{bullet} Question numbers in the online version of the form aren't always consecutive, as we show and hide different questions depending on your previous answers.
      #{bullet} Your information is only shared with those involved in the assessment process.)

    render_text(block_2)

    render_text("Need help?", size: 14, style: :bold)

    block_3 = %(If you need digital assistance with filling in the form or have any questions, please feel free to get in touch with us:
      By calling 020 7215 6880
      Or emailing <b>Kingsawards@beis.gov.uk</b>)

    render_text(block_3)
  end

  def render_logo
    image "#{IMAGES_PATH}#{LOGO_ICON}",
          at: [0, 137.5.mm + DEFAULT_OFFSET],
          width: 25.mm
  end

  def render_urn
    text form_answer.urn,
         header_text_properties
  end

  def render_award_information
    if form_answer.promotion?
      award_title = "King's Award for Enterprise Promotion #{form_answer.award_year.year}"
    else
      award_title = form_answer.decorate.award_application_title_print
    end
    text award_title.upcase,
         header_text_properties.merge(style: :bold)
  end

  def render_company_name
    text "<b>#{form_answer.decorate.company_name.try(:upcase)}</b>",
         header_text_properties.merge(inline_format: true)
  end

  def render_intro_text
    bounding_box([0, cursor], width: 190.mm, height: 40.mm) do
      stroke_color "999999"
      stroke_bounds

      image "#{IMAGES_PATH}#{ALERT_BIG_ICON}",
            at: [5.5.mm, cursor - 3.mm],
            width: 22.5.mm

      intro_text = %(
        This PDF version of the #{form_answer.award_type_full_name} Award #{form_answer.promotion? ? 'nomination' : 'application'} is for <b>reference only</b>.

        To apply for this award, <b>you must complete the online form</b>. <b>Do not send this PDF version of the form</b> to apply for this award.
      )

      text_box intro_text,
               at: [35.mm, cursor - 3.mm],
               width: 145.mm,
               inline_format: true
    end
  end

  def render_standart_answer_block(title)
    if title.present?
      indent 7.mm do
        render_text title, color: FormPdf::DEFAULT_ANSWER_COLOR
      end
    end
  end

  def render_text(title, ops = {})
    default_bottom_margin

    ##
    # force title to be a String, as Integer may
    # raise undefined method `gsub'
    text title.to_s, ops.merge!({inline_format: true})
  end

  def render_table(table_lines, ops = {})
    default_options = {
      row_colors: %w(F0F0F0 FFFFFF),
      cell_style: { size: 10, font_style: :bold }
    }

    options = {}.merge(default_options).merge(ops)

    default_bottom_margin
    table table_lines, options
  end

  def render_header(title)
    text title, style: :bold,
                size: 16,
                align: :left
    stroke_color = "999999"
    move_down 4.mm
    stroke_horizontal_line 0, 192.mm
    default_bottom_margin
  end

  def current_host
    default_url_options = ActionMailer::Base.default_url_options

    host = default_url_options[:host]
    port = default_url_options[:port]

    "http://#{host}#{port ? ':' + port.to_s : ''}"
  end

  def default_bottom_margin
    move_down 5.mm
  end

  def header_text_properties
    {
      width: 160.mm,
      size: 16,
      align: :left,
      valign: :top
    }
  end

  def render_value_or_undefined(val, undefined_text)
    val.present? ? val : undefined_text
  end
end
