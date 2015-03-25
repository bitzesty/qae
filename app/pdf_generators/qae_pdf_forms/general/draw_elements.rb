module QaePdfForms::General::DrawElements
  DEFAULT_OFFSET = 110.mm
  IMAGES_PATH = "#{Rails.root}/app/assets/images/"
  LOGO_ICON = "logo-pdf.png"
  ATTACHMENT_ICON = "icon-attachment.png"
  ALERT_ICON = "icon-important-print.png"
  ALERT_BIG_ICON = "icon-important-big-print.png"

  def attachment_icon(attachment)
    case attachment.file.file.extension.to_s
    when *FormAnswerAttachmentUploader::POSSIBLE_IMG_EXTENSIONS
      "#{Rails.root}/public#{attachment.file.url}"
    else
      "#{IMAGES_PATH}#{ATTACHMENT_ICON}"
    end
  end

  def draw_link_with_file_attachment(attachment, description)
    default_bottom_margin
    image attachment_icon(attachment),
          fit: [35, 35],
          align: :left

    move_up 17

    base_link_sceleton(
      "#{current_host}#{attachment.file.url}",
      "#{attachment.file.file.filename.truncate(60)}",
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

  def base_link_sceleton(url, filename, description, ops = {})
    indent (ops[:description_left_margin] || 0) do
      font("Times-Roman") do
        formatted_text [{
                         text: filename,
                         link: url,
                         styles: [:underline]
                       }]

        move_down 3.mm

        text description,
             color: "999999"
      end
    end
  end

  def main_header
    render_logo
    render_award_information
    render_user_information
    render_urn if form_answer.urn.present?

    move_down 45.mm

    unless form_answer.urn.present?
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
    text_box form_answer.urn,
             header_text_properties.merge(at: [32.mm, 137.5.mm + DEFAULT_OFFSET])
  end

  def render_award_information
    text_box form_answer.decorate.award_application_title.upcase,
             header_text_properties.merge(at: [32.mm, 130.mm + DEFAULT_OFFSET],
                                               style: :bold)
  end

  def render_user_information
    text_box user.decorate.general_info_print,
             header_text_properties.merge(at: [32.mm, 122.mm + DEFAULT_OFFSET],
                                          inline_format: true)
  end

  def render_intro_text
    bounding_box([0, cursor], :width => 190.mm, :height => 40.mm) do
      stroke_color "999999"
      stroke_bounds

      image "#{IMAGES_PATH}#{ALERT_BIG_ICON}",
            at: [5.5.mm, cursor - 3.mm],
            width: 22.5.mm

      intro_text = %(
        This PDF version of the #{form_answer.decorate.award_type} Award application is for <b>reference only</b>.

        <b>Please do not send in</b> this form to apply for this award. To apply for this award, complete this form online.
      )

      text_box intro_text,
            at: [35.mm, cursor - 3.mm],
            width: 145.mm,
            inline_format: true
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
end
