class CaseSummaryPdfs::Base < ReportPdfBase

  attr_reader :form_answers

  def all_mode
    set_form_answers

    if form_answers.present?
      form_answers.each_with_index do |form_answer, index|
        start_new_page if index.to_i != 0
        render_item(form_answer)
      end
    else
      @missing_data_name = "case summaries"
      render_not_found_block
    end
  end

  def set_form_answers
    @form_answers = FormAnswer.positive
                              .includes(:lead_or_primary_assessor_assignments)
                              .for_award_type(options[:category])
                              .joins(:assessor_assignments)
                              .group("form_answers.id")
                              .having("count(assessor_assignments) > 0")
                              .where("assessor_assignments.submitted_at IS NOT NULL AND assessor_assignments.position IN (3,4)")
                              .order("form_answers.award_year_id, form_answers.sic_code")
                              .group("form_answers.id")
                              .where("form_answers.award_year_id =?", current_year.id)
  end

  def render_item(form_answer)
    CaseSummaryPdfs::Pointer.new(self, form_answer)
  end
end
