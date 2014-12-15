class Eligibility::Development < Eligibility
  AWARD_NAME = 'The Sustainable Development Award'

  property :sustainable_development, boolean: true, label: "Has your organisation had a substantial sustainable development iniative for at least the last two years?", accept: :true
  property :development_contributed_to_commercial_success, boolean: true, label: "Can you demonstrate that your sustainable development is accompanied by - and contributes to - commercial success?", accept: :true, hint: "If figures such as profitability, turnover and market share have met/exceeded business plan targets, then you can demonstrate 'commercial success'."
end
