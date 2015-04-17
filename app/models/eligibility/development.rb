class Eligibility::Development < Eligibility
  AWARD_NAME = 'Sustainable Development'

  property :sustainable_development,
            values: %w[yes no skip],
            acts_like_boolean: true,
            label: "Have you had a substantial sustainable development initiative for at least the last two years?",
            accept: :true
end
