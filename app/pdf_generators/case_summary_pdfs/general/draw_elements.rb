module CaseSummaryPdfs::General::DrawElements
  def main_header
    render_logo
    render_urn
    render_applicant
    render_sub_category unless form_answer.promotion?
    render_award_general_information
    render_award_title
  end
end
