class Eligibility::Basic < Eligibility
  property :kind, values: %w[application nomination], label: "Do you want to apply for an award for your organisation, or nominate an individual?", accept: :not_nil
  property :based_in_uk, boolean: true, label: "Is the part of your organisation you wish to enter for a Queen's Award based in the UK?", accept: :true
  property :has_management_and_two_employees, boolean: true, label: "Does the part of your organisation you wish to enter for a Queen's Award have two or more full-time UK employees?", accept: :true
  property :organization_kind, values: %w[business charity], label: "What kind of organisation is it?", accept: :not_nil
  property :industry, values: %w[product_business service_business], label: "Is the part of your business you wish to enter mainly:", accept: :not_nil_or_charity
  property :registered, boolean: true, label: "Is the part of your organisation you wish to enter for a Queen's Award registered with the UK Government?", accept: :not_nil
  property :self_contained_enterprise, boolean: true, label: "Has it been acting as a self-contained operational unit?", accept: :true
  property :demonstrated_comercial_success, boolean: true, label: "Can you demonstrate commercial success in the part of your organisation you wish to enter?", accept: :true
  property :current_holder, boolean: true, label: "Are you a current Queen's Award holder?", accept: :not_nil

  def eligible?
    current_step_index = self.class.questions.index(current_step) || self.class.questions.size - 1
    previous_questions = self.class.questions[0..current_step_index]

    answers.any? && answers.all? do |question, answer|
      if previous_questions.include?(question.to_sym)
        answer_valid?(question, answer)
      else
        true
      end
    end
  end

  private

  def set_passed
    if current_step == :current_holder && eligible?
      update_column(:passed, true)
    end
  end
end
