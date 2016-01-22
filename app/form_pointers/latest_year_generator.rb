module LatestYearGenerator
  def calculate_last_year(form_answer, month)
    # Conditional latest year
    # If from October to December -> then previous year
    # If from January to September -> then current year

    @form_answer_award_year = form_answer.award_year.year unless @form_answer_award_year.present?

    if month.present? && month.to_i >= 10
      @form_answer_award_year - 2
    else
      @form_answer_award_year - 1
    end

  end
end
