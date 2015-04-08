module FeedbackPdfs::General::DrawElements
  DEFAULT_OFFSET = 50.mm
  IMAGES_PATH = "#{Rails.root}/app/assets/images/"
  LOGO_ICON = "logo-pdf.png"
  AWARD_GENERAL_INFO_PREFIX = "The Queen's Awards for Enterprise"

  def main_header
    render_logo
    render_urn
    render_applicant
    render_sub_category unless form_answer.promotion?
    render_award_general_information
    render_award_title
  end

  def render_logo
    pdf_doc.image "#{IMAGES_PATH}#{LOGO_ICON}",
                  at: [0, 137.5.mm + DEFAULT_OFFSET],
                  width: 25.mm
  end

  def render_urn
    pdf_doc.text_box "QA Ref: #{form_answer.urn}",
                     header_text_properties.merge(at: [32.mm, 137.mm + DEFAULT_OFFSET])
  end

  def render_applicant
    pdf_doc.text_box "Applicant: #{user.decorate.applicant_info_print}",
                     header_text_properties.merge(at: [32.mm, 129.5.mm + DEFAULT_OFFSET])
  end

  def render_sub_category
    pdf_doc.text_box "Sub-category: #{sub_category}",
                     header_text_properties.merge(at: [32.mm, 122.mm + DEFAULT_OFFSET])
  end

  def render_award_general_information
    pdf_doc.text_box "#{AWARD_GENERAL_INFO_PREFIX} #{form_answer.award_year.year}",
                     header_text_properties.merge(at: [163.mm, 137.mm + DEFAULT_OFFSET])
  end

  def render_award_title
    pdf_doc.text_box form_answer.award_type.capitalize,
                     header_text_properties.merge(at: [163.mm, 129.5.mm + DEFAULT_OFFSET])
  end

  def render_headers(table_lines)
    pdf_doc.move_down 30.mm
    pdf_doc.table table_lines, row_colors: %w(F0F0F0),
                               cell_style: { size: 12, font_style: :bold },
                               column_widths: {
                                 0 => 100,
                                 1 => 100,
                                 2 => 567
                               }
  end

  def render_table(table_lines)
    pdf_doc.table table_lines, row_colors: %w(FFFFFF),
                               cell_style: { size: 12 },
                               column_widths: {
                                 0 => 100,
                                 1 => 100,
                                 2 => 567
                               }
  end

  def render_not_found_block
    render_logo
    render_not_found_message
  end

  def render_not_found_message
    pdf_doc.text_box "No feedbacks found by selected category!",
                     header_text_properties.merge(at: [32.mm, 137.mm + DEFAULT_OFFSET])
  end

  def default_bottom_margin
    pdf_doc.move_down 5.mm
  end

  def header_text_properties
    {
      width: 160.mm,
      size: 16,
      align: :left,
      valign: :top,
      style: :bold
    }
  end
end
