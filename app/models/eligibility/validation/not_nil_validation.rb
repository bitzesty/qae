class Eligibility::Validation::NotNilValidation < Eligibility::Validation::Base
  def valid?
    !answer.nil?
  end
end
