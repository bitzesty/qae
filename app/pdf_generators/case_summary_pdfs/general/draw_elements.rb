module CaseSummaryPdfs::General::DrawElements
  ONE_LINE_OFFSET = 8.mm

  def default_offset
    SharedPdfHelpers::DrawElements::DEFAULT_OFFSET
  end

  def sic_code_offset
    @sic_code_offset ||= if sic_code.length > 100
      -5.mm
    else
      0.mm
    end
  end

  def main_header
    render_official_sensitive(105, 137.5)
    render_logo(695, 127.5)
    render_urn(0, 127)
    render_applicant(0, 119.5)

    unless form_answer.promotion?
      render_organization_type
      render_sic_code

      if (form_answer.development? || form_answer.mobility?) && form_answer.award_year.year >= 2020
        # type and sub category Qs are missing for SD2020+, so need to move up
        render_current_awards(offset: ONE_LINE_OFFSET + sic_code_offset)
      else
        render_type(offset: sic_code_offset)
        render_current_awards(offset: sic_code_offset)
        render_sub_category(0, y_coord("sub_category") + sic_code_offset.to_i)
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

  def render_type(offset: 0.mm)
    pdf_doc.text_box "Type: #{application_type}",
            header_text_properties.merge(
      at: [0.mm, 97.mm + default_offset + offset],
      width: 272.mm
    )
  end

  def y_coord(mode)
    mode_number = case mode
    when "awards"
      0
    when "sub_category"
      1
    when "general_block"
      2
    end

    if form_answer.award_type == "mobility" &&
       form_answer.award_year.year < 2020 &&
       application_type_answer.size > 0
      case application_type_answer.size
      when 1
        [79, 71, 75]
      when 2
        [74, 67, 81]
      when 3
        [69, 62, 85]
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
    awards = current_awards
    awards = [awards] if awards.is_a?(String)

    awards.each_with_index do |awards_line, index|
      if index == 0
        pdf_doc.text_box "Current Awards: #{awards_line}",
                         header_text_properties.merge(width: 650.mm, at: [0.mm, y_coord("awards").mm + default_offset + offset])
      else
        pdf_doc.text_box "#{awards_line}",
                         header_text_properties.merge(width: 650.mm, at: [0.mm, y_coord("awards").mm + default_offset + offset - index * ONE_LINE_OFFSET])

        pdf_doc.move_down ONE_LINE_OFFSET
      end
    end

  end
end
