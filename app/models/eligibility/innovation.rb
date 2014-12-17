class Eligibility::Innovation < Eligibility
  AWARD_NAME = 'Innovation'

  validates :number_of_innovative_products, presence: true, numericality: { only_integer: true, greater_than_0: true, allow_nil: true }, if: proc { innovative_product? && (!current_step || current_step == :number_of_innovative_products) }

  property :innovative_product, values: %w[yes no skip], acts_like_boolean: true, label: "Do you have an innovative product/service/initiative?", accept: :true, hint: 'A product/service/initiative is innovative if it has not been done before, and provides benefit/ solves prior problems for its users. Fields include invention, design and production (for goods), performance (for services), marketing, distribution, after-sale support.'
  property :number_of_innovative_products, positive_integer: true, label: "How many innovative products/services/initiatives do you have?", accept: :not_nil, if: proc { !skipped? && (innovative_product.nil? || innovative_product?) }
  property :was_on_market_for_two_years, boolean: true, label: "Has it been on the market for at least two years?", accept: :true, if: proc { !skipped? }
  property :innovation_recouped_investments, boolean: true, label: "Have you recovered all investments made in the innovation?", accept: :true, hint: 'This includes any initial invesments you made, as well as those made subsequently.', if: proc { !skipped? }
  property :had_impact_on_commercial_performace_over_two_years, boolean: true, label: "Has the innovation had a positive impact on your commercial success (i.e. turnover and/or profitability) over at least the last two years?", accept: :true, if: proc { !skipped? }
end
