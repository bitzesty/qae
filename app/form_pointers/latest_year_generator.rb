module LatestYearGenerator
  def calculate_last_year(form_answer, day, month)
    # Conditional latest year
    # If from 3rd of September to December -> then previous year
    # If from January to 2nd of September -> then current year
    #

    @form_answer_award_year = form_answer.award_year.year unless @form_answer_award_year.present?

    if (month.to_i == 9 && day.to_i >= 3) || month.to_i > 9
      @form_answer_award_year - 2
    else
      @form_answer_award_year - 1
    end
  end
end
