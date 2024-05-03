class PreviousWin
  CATEGORIES = {
    "Innovation" => "innovation",
    "International Trade" => "international_trade",
    "Sustainable Development" => "sustainable_development",
    "Promoting Opportunity" => "social_mobility",
  }

  def self.available_years
    current_year = AwardYear.current.year
    ((current_year - 10)..(current_year - 1)).to_a
  end
end
