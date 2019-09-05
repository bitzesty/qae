module CaseSummaryPdfs::General::DrawElements
  def default_offset
    SharedPdfHelpers::DrawElements::DEFAULT_OFFSET
  end

  def main_header
    render_official_sensitive(105, 137.5)
    render_logo(695, 127.5)
    render_urn(0, 127)
    render_applicant(0, 119.5)

    unless form_answer.promotion?
      render_organization_type
      render_sic_code

      if form_answer.development? && form_answer.award_year.year >= 2020
        # type and sub category Qs are missing for SD2020+, so need to move up
        render_current_awards(offset: 8.mm)
      else
        render_type
        render_current_awards
        render_sub_category(0, y_coord('sub_category'))
      end
    end

    render_award_general_information(130, 127)
    render_award_title(130, 119.5)
  end

  def render_organization_type
    pdf_doc.text_box "Organisation Type: #{organisation_type}", header_text_properties.merge(
      at: [0.mm, 112.mm + default_offset]
    )
  end

  def render_type
    pdf_doc.text_box "Type: #{application_type}",
            header_text_properties.merge(
      at: [0.mm, 97.mm + default_offset],
      width: 272.mm
    )
  end

  def y_coord(mode)
    mode_number = case mode
    when 'awards'
      0
    when 'sub_category'
      1
    when 'general_block'
      2
    end

    if form_answer.award_type == "mobility" &&
       application_type_answer.size > 0
      case application_type_answer.size
      when 1
        [84, 76, 70]
      when 2
        [79, 72, 76]
      when 3
        [74, 67, 80]
      end
    else
      [89, 81, 65]
    end[mode_number]
  end

  def render_sic_code
    pdf_doc.text_box "SIC code: #{sic_code}",
            header_text_properties.merge(width: 272.mm, at: [0.mm, 104.5.mm + default_offset])
  end

  def render_current_awards(offset: 0)
    pdf_doc.text_box "Current Awards: #{current_awards}",
            header_text_properties.merge(width: 650.mm, at: [0.mm, y_coord('awards').mm + default_offset + offset])
  end
end
