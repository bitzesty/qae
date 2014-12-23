module QaePdfForms::General::DrawElements
  DEFAULT_OFFSET = 110.mm
  LOGO_ICON = "logo.png"
  LINK_ICON = "icon-link.png"
  DOWNLOAD_ICON = "icon-download.png"
  ATTACHMENT_ICON = "icon-attachment.png"
  IMAGES_PATH = "#{Rails.root}/app/assets/images/"

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
          fit: [35, 35], align: :left
    move_up 20

    base_link_sceleton(
      "#{current_host}#{attachment.file.url}", 
      description ? description : attachment.file.file.filename, 
      DOWNLOAD_ICON,
      {description_left_margin: 100})
  end

  def draw_link(v)
    default_bottom_margin
    base_link_sceleton(
      v["link"], 
      v["description"] ? v["description"] : v["link"], 
      LINK_ICON, 
      {})
  end

  def base_link_sceleton(url, description, icon, ops={})
    text_box description, at: [ops[:description_left_margin] || 0, cursor], style: :italic

    move_up 7
    bounding_box([460, cursor], width: 20) do
      image "#{IMAGES_PATH}#{icon}",
            fit: [20, 20], 
            align: :center

      move_up 20

      transparent(0) do
        formatted_text([{
          text: "|||",
          size: 25,
          link: url,
        }], align: :center)
      end
    end

    move_up 24
    formatted_text([{
      text: "Visit",
      link: url,
      styles: [:italic]
    }], align: :right)
  end

  def main_header
    render_logo
    render_award_information
    render_user_information
    render_urn if form_answer.urn.present?

    move_down 40.mm
  end

  def render_logo
    stroke_rectangle [0, 138.5.mm + DEFAULT_OFFSET], 200.mm, 24.mm
    image "#{IMAGES_PATH}#{LOGO_ICON}", at: [2.mm, 137.5.mm + DEFAULT_OFFSET], width: 25.mm
  end

  def render_award_information
    stroke_line 29.mm, 138.5.mm + DEFAULT_OFFSET, 29.mm, 114.5.mm + DEFAULT_OFFSET
    text_box form_answer.decorate.award_application_title, 
             default_text_box_properties.merge({
               at: [32.mm, 142.mm + DEFAULT_OFFSET]
             })
  end

  def render_user_information
    text_box user.decorate.general_info, 
             default_text_box_properties.merge({
               at: [32.mm, 135.mm + DEFAULT_OFFSET]
             })
  end

  def render_urn
    text_box form_answer.render_urn, 
      default_text_box_properties.merge({
        at: [32.mm, 129.mm + DEFAULT_OFFSET]
      })
  end

  def render_text(title, ops={})
    default_bottom_margin
    text title, ops
  end

  def render_table(table_lines)
    default_bottom_margin
    table table_lines, row_colors: ["F0F0F0", "FFFFFF"],
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

  def default_text_box_properties
    {
      width: 200.mm, 
      height: 20.mm, 
      size: 18, style: :bold, 
      align: :left, 
      valign: :center      
    }
  end
end