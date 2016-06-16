# -*- coding: utf-8 -*-
require 'open-uri'

module QaePdfForms::General::DrawElements
  DEFAULT_OFFSET = 110.mm
  IMAGES_PATH = "#{Rails.root}/app/assets/images/"
  LOGO_ICON = "logo-pdf.png"
  ATTACHMENT_ICON = "icon-attachment.png"
  ALERT_ICON = "icon-important-print.png"
  ALERT_BIG_ICON = "icon-important-big-print.png"

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
      description ? description : nil,
      description_left_margin: 55)

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
      font("Times-Roman") do
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
  end

  def main_header
    render_logo
    move_down 8.mm
    indent 32.mm do
      render_urn if form_answer.urn.present? && pdf_blank_mode.blank?
      render_award_information
      render_company_name unless pdf_blank_mode.present?
    end

    move_down 15.mm

    if !form_answer.urn.present? || pdf_blank_mode
      render_intro_text

      move_down 15.mm
    end
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
      award_title = "Queen's Award for Enterprise Promotion #{form_answer.award_year.year}"
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

        <b>Please do not send in</b> this form to apply for this award. To apply for this award, you have to complete the online form.
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
        font("Times-Roman") do
          render_text title, color: FormPdf::DEFAULT_ANSWER_COLOR
        end
      end
    end
  end

  def render_text(title, ops = {})
    default_bottom_margin
    text title, ops
  end

  def render_table(table_lines)
    default_bottom_margin
    table table_lines, row_colors: %w(F0F0F0 FFFFFF),
                       cell_style: { size: 10, font_style: :bold }
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
