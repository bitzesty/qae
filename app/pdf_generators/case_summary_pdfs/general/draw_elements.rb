module CaseSummaryPdfs::General::DrawElements
  def default_offset
    SharedPdfHelpers::DrawElements::DEFAULT_OFFSET
  end

  def main_header
    render_logo(695, 137.5)
    render_urn(0, 137)
    render_applicant(0, 129.5)
    render_employees
    render_sic_code
    render_current_awards
    render_sub_category(0, 99.5) unless form_answer.promotion?
    render_award_general_information(130, 137)
    render_award_title(130, 129.5)
  end

  def render_employees
    pdf_doc.text_box "Employees: #{employees}",
            header_text_properties.merge(at: [0.mm, 122.mm + default_offset])
  end

  def render_sic_code
    pdf_doc.text_box "SIC code: #{sic_code}",
            header_text_properties.merge(at: [0.mm, 114.5.mm + default_offset])
  end

  def render_current_awards
    pdf_doc.text_box "Current Awards: #{current_awards}",
            header_text_properties.merge(width: 650.mm, at: [0.mm, 107.mm + default_offset])
  end
end
