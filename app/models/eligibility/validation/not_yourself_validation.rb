class Eligibility::Validation::NotYourselfValidation < Eligibility::Validation::Base
  def valid?
    eligibility.nominee != "yourself"
  end
end
