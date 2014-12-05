class Eligibility::Validation::Base
  attr_reader :eligibility, :question, :answer

  def initialize(eligibility, question, answer)
    @eligibility = eligibility
    @question = question
    @answer = answer
  end

  def valid?
    raise NotImplementedError
  end
end
