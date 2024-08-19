module LatestYearGenerator
  def calculate_last_year(form_answer, day, month)
    if form_answer.document["most_recent_financial_year"]
      @form_answer_award_year = form_answer.document["most_recent_financial_year"].to_i
    else
      # Conditional latest year
      # If from 7th of September to December -> then previous year
      # If from January to 6th of September -> then current year
      #
      @form_answer_award_year = form_answer.award_year.year if @form_answer_award_year.blank?

      if form_answer.financial_year_changeable? || (month.to_i == 9 && day.to_i > 6) || month.to_i > 9
        @form_answer_award_year - 2
      else
        @form_answer_award_year - 1
      end
    end
  end
end
