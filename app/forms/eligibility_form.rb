class EligibilityForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :form_answer

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def eligibility
    @eligibility ||= form_answer.eligibility || form_answer.build_eligibility
  end

  def basic_eligibility
    @basic_eligibility ||= form_answer.basic_eligibility || form_answer.build_basic_eligibility
  end

  def update(attrs = {})
    if valid?
      eligibility.update(attrs[:eligibility])
      basic_eligibility.update(attrs[:basic_eligibility])
    else
      false
    end
  end

  def valid?
    eligibility.valid? && basic_eligibility.valid?
  end

  def persisted?
    false
  end
end
