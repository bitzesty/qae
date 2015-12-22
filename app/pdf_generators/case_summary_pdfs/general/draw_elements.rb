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
      render_employees
      render_sic_code
      render_current_awards
      render_sub_category(0, 89.5)
    end

    render_award_general_information(130, 127)
    render_award_title(130, 119.5)
  end

  def render_employees
    pdf_doc.text_box "Employees: #{employees}",
            header_text_properties.merge(at: [0.mm, 112.mm + default_offset])
  end

  def render_sic_code
    pdf_doc.text_box "SIC code: #{sic_code}",
            header_text_properties.merge(at: [0.mm, 104.5.mm + default_offset])
  end

  def render_current_awards
    pdf_doc.text_box "Current Awards: #{current_awards}",
            header_text_properties.merge(width: 650.mm, at: [0.mm, 97.mm + default_offset])
  end
end
