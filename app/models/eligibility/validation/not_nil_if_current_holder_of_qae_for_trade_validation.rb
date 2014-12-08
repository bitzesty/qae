class Eligibility::Validation::NotNilIfCurrentHolderOfQaeForTradeValidation < Eligibility::Validation::Base
  def valid?
    eligibility.current_holder_of_qae_for_trade? ? !answer.nil? : true
  end
end
