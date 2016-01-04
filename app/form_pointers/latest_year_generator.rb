module LatestYearGenerator
  def calculate_last_year(form_answer, month)
    # Conditional latest year
    # If from October to December -> then previous year
    # If from January to September -> then current year

    if month.present? && month.to_i >= 10
      form_answer.award_year.year - 2
    else
      form_answer.award_year.year - 1
    end

  end
end
