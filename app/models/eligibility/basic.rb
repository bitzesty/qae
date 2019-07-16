class Eligibility::Basic < Eligibility
  AWARD_NAME = 'General'
  after_save :set_passed

  property :based_in_uk,
            boolean: true,
            label: "Is your organisation based in the UK (including the Channel Islands and the Isle of Man)?",
            accept: :true

  property :do_you_file_company_tax_returns,
            values: %w[true false na], 
            label: "Do you file your Company Tax Returns with HM Revenue and Customs (HMRC)?",
            hint: "All companies and partnerships have to select Yes or No. However, if you are a charity or are based in the Channel Islands or the Isle of Man and do not pay tax to the HMRC, please select N/A.",
            accept: :not_no

  property :has_management_and_two_employees,
            boolean: true,
            label: "Did your organisation have two or more full-time UK employees (FTE) in each year of your entry?",
            accept: :true,
            hint: "Part-time staff should be counted in full-time equivalents. The number of years you will have to enter will depend on the award you are applying for - it is a minimum of three years for the International Trade award and a minimum of two years for all other awards."

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
           values: %w[yes no i_dont_know],
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
