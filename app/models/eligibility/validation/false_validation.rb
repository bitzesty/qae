class Eligibility::Validation::FalseValidation < Eligibility::Validation::Base
  def valid?
    p eligibility.public_send("#{question}?"), question, eligibility.public_send(question)
    !eligibility.public_send("#{question}?")
  end
end
