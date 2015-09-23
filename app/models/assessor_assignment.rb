class AssessorAssignment < ActiveRecord::Base
  enum position: {
    primary: 0,
    secondary: 1,
    moderated: 2,
    lead_case_summary: 4
  }

  begin :validations
    validates :form_answer_id,
              :position,
              presence: true

    validate :award_specific_attributes
    validate :mandatory_fields_for_submitted

    validate do
      validate_rate :rag
      validate_rate :strengths
      validate_rate :verdict
    end

    validate :submitted_at_immutability
    validate :assessor_existence
    validate :assessor_assignment_to_category
    validates :assessor_id,
              uniqueness: { scope: [:form_answer_id] },
              allow_nil: true
  end

  begin :associations
    belongs_to :assessor
    belongs_to :form_answer
    belongs_to :editable, polymorphic: true
  end

  begin :scopes
    scope :submitted, -> { where.not(submitted_at: nil) }
  end

  around_save :notify_form_answer

  store_accessor :document, *AppraisalForm.all

  def self.primary
    find_or_create_by(position: 0)
  end

  def self.secondary
    find_or_create_by(position: 1)
  end

  def self.moderated
    find_or_create_by(position: 2)
  end

  def self.lead_case_summary
    find_or_create_by(position: 4)
  end

  def submitted?
    submitted_at.present?
  end

  def visible_for?(subject)
    return true if owner_or_administrative?(subject)
    # regular assessors flow
    assessments = Array(self)
    assessments << form_answer.assessor_assignments.secondary if primary?
    assessments << form_answer.assessor_assignments.primary if secondary?

    if assessments.all?(&:submitted?)
      return assessments.any? { |a| a.assessor_id == subject.id }
    end
    false
  end

  def editable_for?(subject)
    owner_or_administrative?(subject)
  end

  def as_json
    if errors.blank?
      {}
    else
      { error: errors.full_messages }
    end
  end

  private

  def owner_or_administrative?(subject)
    subject.is_a?(Admin) ||
      subject.try(:lead?, form_answer) ||
      (!moderated? && !lead_case_summary? && assessor_id == subject.id)
  end

  def award_specific_attributes
    struct.diff(form_answer.award_type, moderated?).each do |att|
      if public_send(att).present?
        errors.add(att, "Can not be present for this Award Type")
      end
    end
  end

  def mandatory_fields_for_submitted
    return unless submitted?
    struct.meths_for_award_type(form_answer.award_type, moderated?).each do |meth|
      if public_send(meth).blank?
        errors.add(meth, "can not be blank for submitted assessment")
      end
    end
  end

  def validate_rate(rate_type)
    return if moderated? && rate_type != :verdict
    struct.rates(form_answer, rate_type).each do |section, _|
      val = section_rate(section)
      c = "#{rate_type.upcase}_ALLOWED_VALUES"
      if val && !struct.const_get(c).include?(val)
        sect_name = struct.rate(section)
        errors.add(sect_name, "#{rate_type} field has not permitted value")
      end
    end
  end

  def section_rate(section)
    public_send(struct.rate(section))
  end

  def struct
    AppraisalForm
  end

  def submitted_at_immutability
    return if new_record?
    if submitted_at_changed? && submitted_at_was.present?
      errors.add(:submitted_at, "Can not be re-submitted")
    end
  end

  def assessor_existence
    if (moderated? || lead_case_summary?) && assessor_id.present?
      errors.add(:assessor_id, "Can not be present for this kind of assessment.")
    end
  end

  def assessor_assignment_to_category
    return unless assessor_id_changed?
    if assessor.present? && !assessor.assignable?(form_answer)
      errors.add(:assessor_id, "Can not be assigned to this case.")
    end
  end

  def notify_form_answer
    # I would like to be in builder class probably
    if primary? || secondary?
      assessor_changed = assessor_id_changed?
    end

    yield

    if assessor_changed
      attribute = (primary? ? :primary_assessor_id : :secondary_assessor_id)
      form_answer.update(attribute => assessor_id)
    end
  end
end
