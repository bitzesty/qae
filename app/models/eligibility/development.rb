class Eligibility::Development < Eligibility
  AWARD_NAME = 'Sustainable Development'

  property :sustainable_development,
            values: %w[yes no skip],
            acts_like_boolean: true,
            label: "Have you had a substantial sustainable development action or intervention for at least the last two years?",
            accept: :true

  def self.award_name
    AWARD_NAME + " Award"
  end

end
