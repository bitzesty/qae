class Eligibility::Innovation < Eligibility
  extend Enumerize

  property :innovative_product, boolean: true, label: "Do you have an innovative product/service/initiative?", accept: :true
  property :number_of_innovative_products, positive_integer: true, label: "How many?", accept: :not_nil
  property :was_on_market_for_two_years, boolean: true, label: "Has it been released to the market for at least two years?", accept: :true
  property :had_impact_on_commercial_performace_over_two_years, boolean: true, lable: "Has the innovation had a measurable positive impact on your commercial performance over at least the last two years??", accept: :true

  def eligible?
    answers && answers.any? && answers.all? do |question, answer|
      answer_valid?(question, answer)
    end
  end

  private

  def set_passed
    if eligible?
      update_column(:passed, true)
    end
  end
end
