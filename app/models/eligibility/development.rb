class Eligibility::Development < Eligibility
  AWARD_NAME = 'Sustainable Development'

  property :sustainable_development, boolean: true, label: "Have you had a substantial sustainable development initiative for at least the last two years?", accept: :true
  property :demonstrate_development_activities, boolean: true, label: "Can you provide quantitative data to demonstrate your sustainable development activities?", accept: :true, hint: "e.g. energy use per unit of production, % of waste recycled, % of materials sourced fair trade."
  property :development_contributed_to_commercial_success, boolean: true, label: "Has your sustainable development had a positive impact on your commercial success over the last two years?", accept: :true, hint: "e.g. increased profitability/turnover, created new markets, improved market share."
end
