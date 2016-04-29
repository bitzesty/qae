class Eligibility::Validation::NotNilIfCurrentHolderOfQaeForTradeValidation < Eligibility::Validation::Base
  def valid?
    return true unless eligibility.current_holder_of_qae_for_trade?

    answer.to_i < Date.today.year
  end
end
