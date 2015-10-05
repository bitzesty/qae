class PreviousWin
  CATEGORIES = {
    "Innovation" => "innovation",
    "Internation Trade" => "international_trade",
    "Sustainable Development" => "sustainable_development"
  }

  def self.available_years
    current_year = AwardYear.current.year
    ((current_year - 5)..(current_year - 1)).to_a
  end
end
