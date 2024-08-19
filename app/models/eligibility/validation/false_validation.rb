class Eligibility::Validation::FalseValidation < Eligibility::Validation::Base
  def valid?
    !eligibility.public_send(:"#{question}?")
  end
end
