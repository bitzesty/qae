class Eligibility::Validation::TrueValidation < Eligibility::Validation::Base
  def valid?
    eligibility.public_send(:"#{question}?")
  end
end
