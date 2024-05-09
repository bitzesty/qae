class EligibilityForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :form_answer

  def initialize(form_answer)
    @form_answer = form_answer
  end

  def eligibility
    @eligibility ||= form_answer.public_send("#{form_answer.award_type}_eligibility") || form_answer.public_send("build_#{form_answer.award_type}_eligibility", filter(form_answer.user.public_send("#{form_answer.award_type}_eligibility").try(:attributes) || {}))
  end

  def basic_eligibility
    @basic_eligibility ||= if form_answer.basic_eligibility.try(:persisted?)
        form_answer.basic_eligibility
    else
        form_answer.build_basic_eligibility(filter(form_answer.user.basic_eligibility.try(:attributes) || {}))
    end
    
  end

  def update(eligibility_attrs, basic_eligibility_attrs)
    eligibility.update(eligibility_attrs)
    basic_eligibility.update(basic_eligibility_attrs)

    valid?
  end

  def valid?
    eligibility.valid? && basic_eligibility.valid?
  end

  def persisted?
    false
  end

  private

  def filter(params)
    params.except("id", "created_at", "updated_at")
  end
end
