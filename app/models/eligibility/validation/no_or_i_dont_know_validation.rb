class Eligibility::Validation::NoOrIDontKnowValidation < Eligibility::Validation::Base
  def valid?
    %w[no i_dont_know].include?(eligibility.public_send(question.to_s))
  end
end
