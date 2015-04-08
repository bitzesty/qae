module FeedbackPdfs::General::DrawElements
  def default_offset
    SharedPdfHelpers::DrawElements::DEFAULT_OFFSET
  end

  def main_header
    render_logo(695, 137.5)
    render_urn(0, 137)
    render_applicant(0, 129.5)
    render_sub_category(0, 122) unless form_answer.promotion?
    render_award_general_information(130, 137)
    render_award_title(130, 129.5)
  end
end
