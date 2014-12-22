class Eligibility::Basic < Eligibility
  AWARD_NAME = 'General'

  property :kind, values: %w[application nomination], label: "Do you want to apply for an award for your organisation, or nominate an individual for the Enterprise Promotion award?", accept: :not_nil
  property :based_in_uk, boolean: true, label: "Is your organisation based in the UK?", accept: :true, if: proc { application? }
  property :has_management_and_two_employees, boolean: true, label: "Does it have two or more full-time UK employees?", accept: :true, if: proc { application? }
  property :organization_kind, values: %w[business charity], label: "What kind of organisation is it?", accept: :not_nil, if: proc { application? }
  property :industry, values: %w[product_business service_business either_business], label: "Is your business mainly a:", accept: :not_nil_or_charity, if: proc { application? && (!organization_kind_value || !organization_kind.charity?) }
  property :registered, boolean: true, label: "Is it registered with the UK Government?", accept: :not_nil, if: proc { application? }
  property :self_contained_enterprise, boolean: true, label: "Does it act as a self-contained operational unit?", accept: :true, if: proc { application? && !registered? }
  property :current_holder, boolean: true, label: "Are you a current Queen's Award holder in any category?", accept: :not_nil, if: proc { application? }

  def application?
    kind_value.nil? || kind.application?
  end

  def nomination?
    kind && kind.nomination?
  end

  def eligible?
    current_step_index = questions.index(current_step) || questions.size - 1
    previous_questions = questions[0..current_step_index]

    answers.any? && answers.all? do |question, answer|
      if previous_questions.include?(question.to_sym)
        answer_valid?(question, answer)
      else
        true
      end
    end
  end

  def skipped?
    false
  end

  private

  def set_passed
    if current_step == questions.last && eligible?
      update_column(:passed, true)
    end
  end
end
