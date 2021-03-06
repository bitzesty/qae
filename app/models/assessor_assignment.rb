class AssessorAssignment < ApplicationRecord

  has_paper_trail unless: Proc.new { |t| Rails.env.test? }

  enum position: {
    primary: 0,
    secondary: 1,
    moderated: 2,
    case_summary: 4
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
    belongs_to :award_year
  end

  begin :scopes
    scope :submitted, -> { where.not(submitted_at: nil) }
  end

  around_save :notify_form_answer

  before_create :set_award_year!

  store_accessor :document, *AppraisalForm.all

  attr_accessor :submission_action

  def self.primary
    find_or_create_by(position: positions[:primary])
  end

  def self.secondary
    find_or_create_by(position: positions[:secondary])
  end

  def self.moderated
    find_or_create_by(position: positions[:moderated])
  end

  def self.case_summary
    find_or_create_by(position: positions[:case_summary])
  end

  def submitted?
    submitted_at.present?
  end

  def locked?
    locked_at.present?
  end

  def visible_for?(subject)
    return true if owner_or_administrative?(subject)
    # Adds ability to view assessments of past applications
    if subject.is_a?(Assessor) && form_answer.from_previous_years?
      return true
    end

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
    role_allow_to_edit?(subject)
  end

  def role_allow_to_edit?(subject)
    admin?(subject) ||
    subject.lead?(form_answer) ||
    primary_assessor_can_edit?(subject) ||
    secondary_assessor_can_edit?(subject)
  end

  def moderated_rag_editable_for?(subject)
    editable_for?(subject) &&
    (position != "moderated" || not_submitted_or_not_locked?)
  end

  def as_json
    if errors.blank?
      {}
    else
      { error: errors.full_messages }
    end
  end

  private

  def admin?(subject)
    subject.is_a?(Admin)
  end

  def owner_or_administrative?(subject)
    admin?(subject) ||
    subject.lead?(form_answer) ||
    primary_or_secondary_assessors_allowed?(subject)
  end

  def primary_or_secondary_assessors_allowed?(subject)
    (case_summary? && subject.primary?(form_answer)) ||
    (!moderated? && !case_summary? && assessor_id == subject.id)
  end

  def primary_assessor_can_edit?(subject)
    not_submitted_or_not_locked? &&
    (primary? || case_summary?) &&
    subject.primary?(form_answer)
  end

  def secondary_assessor_can_edit?(subject)
    not_submitted_or_not_locked? &&
    secondary? &&
    subject.secondary?(form_answer)
  end

  def not_submitted_or_not_locked?
    !submitted? || (submitted? && !locked?)
  end

  def award_specific_attributes
    struct.diff(form_answer, moderated?).each do |att|
      if public_send(att).present?
        errors.add(att, "cannot be present for this Award Type")
      end
    end
  end

  def mandatory_fields_for_submitted
    return if (!submitted? || !submission_action)

    struct.meths_for_award_type(form_answer, moderated?).each do |meth|
      if public_send(meth).blank?
        errors.add(meth, "cannot be blank for submitted assessment")
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

  def assessor_existence
    if (moderated? || case_summary?) && assessor_id.present?
      errors.add(:assessor_id, "cannot be present for this kind of assessment.")
    end
  end

  def assessor_assignment_to_category
    return unless assessor_id_changed?
    if assessor.present? && !assessor.assignable?(form_answer)
      errors.add(:assessor_id, "cannot be assigned to this case.")
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

  def set_award_year!
    self.award_year = form_answer.award_year
  end
end
