class Eligibility::Development < Eligibility
  property :sustainable_development, boolean: true, label: "Has your organisation had a substantial sustainable development iniative for at least the last two years?", accept: :true
  property :development_contributed_to_commercial_success, boolean: true, label: "Can you demonstrate that your sustainable development is accompanied by - and contributes to - commercial success?", accept: :true
  property :can_demonstrate_corporate_responsibility, boolean: true, lable: "Can your business demonstrate corporate responsibility (or commitment to improving its responsibility) in all aspects of its operations? ", accept: :true

  def eligible?
    answers && answers.any? && answers.all? do |question, answer|
      answer_valid?(question, answer)
    end
  end

  private

  def set_passed
    if eligible?
      update_column(:passed, true)
    end
  end
end
