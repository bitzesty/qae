class CaseSummaryPdfs::Base < ReportPdfBase

  attr_reader :form_answers

  def generate!
    if mode == "singular"
      render_item(form_answer)
    else
      all_mode
      add_page_numbers
    end
  end

  def add_page_numbers
    number_pages "<page>", {
      start_count_at: 1,
      at: [
        bounds.right - 50,
        bounds.top + 20
      ],
      align: :right,
      size: 14
    }
  end

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
    scope = FormAnswer.positive
                      .includes(:lead_or_primary_assessor_assignments)
                      .for_award_type(options[:category])
                      .joins(:assessor_assignments)
                      .group("form_answers.id")
                      .having("count(assessor_assignments) > 0")
                      .where("assessor_assignments.submitted_at IS NOT NULL AND assessor_assignments.position IN (3,4)")
                      .order(Arel.sql("form_answers.award_year_id, form_answers.document #>> '{sic_code}'"))
                      .group("form_answers.id")
                      .where("form_answers.award_year_id =?", award_year.id)

    if options[:category] == "trade"
      years_mode = options[:years_mode].to_s == '3' ? '3 to 5' : '6 plus'
      scope = scope.where("form_answers.document #>> '{trade_commercial_success}' = '#{years_mode}'")
    end

    @form_answers = scope
  end

  def render_item(form_answer)
    CaseSummaryPdfs::Pointer.new(self, form_answer)
  end
end
