class Eligibility::Basic < Eligibility
  extend Enumerize

  attr_accessor :current_step

  validate :current_step_validation

  property :kind, values: %w[application nomination], label: "Do you want to apply or nominate?", accept: :not_nil
  property :based_in_uk, boolean: true, label: "Is the part of your organisation you wish to enter for a Queen's Award based in the UK?", accept: :true
  property :has_management_and_two_employees, boolean: true, label: "Does the part of your organisation you wish to enter for a Queen's Award have two or more full-time UK employees?", accept: :true
  property :organization_kind, values: %w[business charity], label: "What kind of organisation is it?", accept: :not_nil
  property :industry, values: %w[product_business service_business], label: "Is the business mainly:", accept: :not_nil_or_charity
  property :registered, boolean: true, label: "Is the part of your organisation you wish to enter for a Queen's Award registered with the UK Government?", accept: :not_nil
  property :self_contained_enterprise, boolean: true, label: "Has it been acting as a self-contained operational unit?", accept: :true
  property :demonstrated_comercial_success, boolean: true, label: "Can you demonstrate commercial success in the part of your organisation you wish to enter?", accept: :true
  property :current_holder, boolean: true, label: "Are you a current Queen's Award holder?", accept: :not_nil

  def eligible?
    current_step_index = self.class.questions.index(current_step) || self.class.questions.size - 1
    previous_questions = self.class.questions[0..current_step_index]

    answers.any? && answers.all? do |question, answer|
      if previous_questions.include?(question.to_sym)
        case self.class.questions_storage[question.to_sym][:accept]
        when :not_nil
          !answer.nil?
        when :true
          public_send("#{question}?")
        when :not_nil_or_charity
          !answer.nil? || organization_kind == 'charity'
        else
          true
        end
      else
        true
      end
    end
  end

  private

  def current_step_validation
    if current_step && public_send(current_step).nil?
      errors.add(current_step, :blank)
    end
  end

  def set_passed
    if current_step == :current_holder && eligible?
      update_column(:passed, true)
    end
  end
end
