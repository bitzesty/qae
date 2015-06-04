module LatestYearGenerator
  def calculate_last_year(month)
    # Conditional latest year
    # If from October to December -> then previous year
    # If from January to September -> then current year

    if month.present? && month.to_i >= 10
      Date.today.year - 1
    else
      Date.today.year
    end
  end
end
