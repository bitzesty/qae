module SharedPdfHelpers::DrawElements
  DEFAULT_OFFSET = 50.mm
  IMAGES_PATH = "#{Rails.root}/app/assets/images/"
  LOGO_ICON = "logo-pdf.png"
  AWARD_GENERAL_INFO_PREFIX = "The King's Awards for Enterprise"

  def render_official_sensitive(x_coord, y_coord)
    pdf_doc.text_box "OFFICIAL - SENSITIVE",
                     header_text_properties.merge(at: [x_coord.mm, y_coord.mm + DEFAULT_OFFSET])
  end

  def render_logo(x_coord, y_coord)
    pdf_doc.image "#{IMAGES_PATH}#{LOGO_ICON}",
                  at: [x_coord, y_coord.mm + DEFAULT_OFFSET],
                  width: 25.mm
  end

  def render_urn(x_coord, y_coord)
    pdf_doc.text_box "KA Ref: #{form_answer.urn}",
                     header_text_properties.merge(at: [x_coord.mm, y_coord.mm + DEFAULT_OFFSET])
  end

  def render_applicant(x_coord, y_coord)
    pdf_doc.text_box "Applicant: #{form_answer.decorate.company_nominee_or_application_name}",
                     header_text_properties.merge(at: [x_coord.mm, y_coord.mm + DEFAULT_OFFSET])
  end

  def render_sub_category(x_coord, y_coord)
    pdf_doc.text_box "Sub-category: #{sub_category}",
                     header_text_properties.merge(at: [x_coord.mm, y_coord.mm + DEFAULT_OFFSET])
  end

  def render_award_general_information(x_coord, y_coord)
    pdf_doc.text_box "#{AWARD_GENERAL_INFO_PREFIX} #{award_year.year}",
                     header_text_properties.merge(at: [x_coord.mm, y_coord.mm + DEFAULT_OFFSET])
  end

  def render_award_title(x_coord, y_coord)
    pdf_doc.text_box form_answer.award_type_full_name.titlecase,
                     header_text_properties.merge(at: [x_coord.mm, y_coord.mm + DEFAULT_OFFSET])
  end

  def render_headers(table_lines, column_widths)
    pdf_doc.move_down 30.mm
    pdf_doc.table table_lines, row_colors: %w[F0F0F0],
                               cell_style: { size: 12, font_style: :bold },
                               column_widths:
  end

  def render_table(table_lines, column_widths = {})
    pdf_doc.table table_lines, row_colors: %w[FFFFFF],
                               cell_style: { size: 12 },
                               column_widths:
  end

  def render_not_found_block
    render_logo(695, 137.5)
    render_not_found_message
    render_not_found_general_information
    render_not_found_category
  end

  def render_not_found_general_information
    pdf_doc.text_box "#{AWARD_GENERAL_INFO_PREFIX} #{award_year.year}",
                     header_text_properties.merge(at: [130.mm, 137.mm + DEFAULT_OFFSET])
  end

  def render_not_found_message
    pdf_doc.text_box "No #{missing_data_name} found by selected category!",
                     header_text_properties.merge(at: [0.mm, 137.mm + DEFAULT_OFFSET])
  end

  def render_not_found_category
    pdf_doc.text_box FormAnswer::AWARD_TYPE_FULL_NAMES[options[:category]],
                     header_text_properties.merge(at: [130.mm, 129.5.mm + DEFAULT_OFFSET])
  end

  def default_bottom_margin
    pdf_doc.move_down 5.mm
  end

  def header_text_properties
    {
      width: 160.mm,
      size: 12,
      align: :left,
      valign: :top,
      style: :bold,
    }
  end
end
