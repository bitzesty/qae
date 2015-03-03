class Eligibility::Basic < Eligibility
  AWARD_NAME = 'General'
  after_save :set_passed

  property :based_in_uk,
            boolean: true,
            label: "Is your organisation based in the UK?",
            accept: :true

  property :has_management_and_two_employees,
            boolean: true,
            label: "Does it have two or more full-time UK employees?",
            accept: :true

  property :organization_kind,
            values: %w[business charity],
            label: "What kind of organisation is it?",
            accept: :not_nil

  property :industry,
            values: %w[product_business service_business either_business],
            label: "Is your business mainly a:",
            accept: :not_nil_or_charity,
            if: proc { !organization_kind_value || !organization_kind.charity? }

  property :self_contained_enterprise,
            boolean: true,
            label: "Is your organisation a self-contained operational unit?",
            accept: :true

  property :current_holder,
            boolean: true,
            label: "Are you a current Queen's Award holder in any category?",
            accept: :not_nil

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
    if (current_step == questions.last) && eligible?
      update_column(:passed, true)
    else
      update_column(:passed, false)
    end
  end
end
