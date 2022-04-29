class Eligibility::Innovation < Eligibility
  AWARD_NAME = 'Innovation'

  validates :number_of_innovative_products, presence: true, numericality: { only_integer: true, greater_than_0: true, allow_nil: true }, if: proc { innovative_product? && (!current_step || current_step == :number_of_innovative_products) }

  property :innovative_product,
            values: %w[yes no skip],
            acts_like_boolean: true,
            label: "Do you have one or more innovative products, services, business models or processes?",
            accept: :true,
            hint: "A product, service, business model or process is innovative if it has not been done before and provides a benefit or solves prior problems for its users."

  property :number_of_innovative_products,
            positive_integer: true,
            label: "How many innovative products, services, business models or processes would you like to enter for the award?",
            accept: :not_nil,
            hint: "You can apply for multiple awards if you have more than one innovation. Each one requires a separate application to be submitted. If so, we recommend that you continue with this application with one innovation in mind and then start new applications for each one of the others.",
            if: proc { !skipped? && (innovative_product.nil? || innovative_product?) }

  property :was_on_market_for_two_years,
            boolean: true,
            label: "Has the innovation been on the market for at least two years?",
            accept: :true,
            hint: "If you have more than one innovation, please decide which one you will be applying for first and answer this and subsequent questions with that innovation in mind.",
            if: proc { !skipped? }

  property :had_impact_on_commercial_performace_over_two_years,
            boolean: true,
            label: "Has the innovation had a positive impact on your commercial success (in terms of turnover or profitability) over at least the last two years?",
            accept: :true,
            if: proc { !skipped? }

  property :have_you_recovered_all_investments,
            boolean: true,
            label: "Have you recovered all the investments made in your innovation or can you demonstrate that the innovation will recover its full costs in the future?",
            accept: :true,
            if: proc { !skipped? }
end
