class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :sustainable_development,
            values: %w[yes no skip],
            acts_like_boolean: true,
            label: "Have you had a substantial sustainable development initiative for at least the last two years?",
            accept: :true
end
