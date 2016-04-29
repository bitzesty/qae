class Eligibility::Validation::NotNilIfCurrentHolderOfQaeForTradeValidation < Eligibility::Validation::Base
  def valid?
    return true unless eligibility.current_holder_of_qae_for_trade?

    Eligibility::Trade::NotWinnerInLastYearValidator.valid_year?(answer)
  end
end
