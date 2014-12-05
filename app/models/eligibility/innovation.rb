class Eligibility::Innovation < Eligibility
  extend Enumerize

  property :innovative_product, boolean: true, label: "Do you have an innovative product/service/initiative?", accept: :true
  property :was_on_market_for_two_years, boolean: true, label: "Has it been released to the market for at least two years?", accept: :true
  property :continuous_innovation_for_five_years, boolean: true, lable: "Has your business or charity presented continuous innovation and development over at least 5 years?", accept: :true

  def eligible?
    answers.any? && answers.all? do |question, answer|
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
