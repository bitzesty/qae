class AssessorAssignment < ApplicationRecord
  has_paper_trail unless: proc { |t| Rails.env.test? }

  enum position: {
    primary: 0,
    secondary: 1,
    moderated: 2,
    case_summary: 4,
  }

  # validations
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

  # associations
  belongs_to :assessor, optional: true
  belongs_to :form_answer, optional: true
  belongs_to :editable, polymorphic: true, optional: true
  belongs_to :award_year, optional: true

  # scopes
  scope :submitted, -> { where.not(submitted_at: nil) }

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
        message = if att.ends_with?("_rate")
          "RAG rating for '#{section_name(att)}' cannot be present for this Award Type"
        else
          "An appraisal comment for '#{section_name(att)}' cannot be present for this Award Type"
        end

        errors.add(att, message: message)
      end
    end
  end

  def mandatory_fields_for_submitted
    return if !submitted? || !submission_action

    struct.meths_for_award_type(form_answer, moderated?).each do |meth|
      if public_send(meth).blank?
        message = if meth.ends_with?("_rate")
          "RAG rating is required for '#{section_name(meth)}'. Select an option from the dropdown list."
        else
          "An appraisal comment is required for '#{section_name(meth)}' and must be filled in."
        end

        errors.add(meth, message: message)
      end
    end
  end

  def validate_rate(rate_type)
    return if moderated? && rate_type != :verdict
    struct.rates(form_answer, rate_type).each do |section, _|
      val = section_rate(section)
      c = "#{rate_type.upcase}_ALLOWED_VALUES"
      if val && struct.const_get(c).exclude?(val)
        sect_name = struct.rate(section)
        message = "#{rate_type} field for '#{section_name(section)}' has not permitted value."
        errors.add(sect_name, message: message)
      end
    end
  end

  def section_rate(section)
    public_send(struct.rate(section))
  end

  def section_name(key)
    @_sections ||= struct.struct(form_answer).to_h
    section_key = key.to_s.gsub(/_desc$/, "").gsub(/_rate$/, "")
    if (section = @_sections.dig(section_key.to_sym))
      section[:label].gsub(/:$/, "")
    end
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
