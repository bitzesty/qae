class AssessorAssignment < ActiveRecord::Base
  PRIMARY_POSITION = 0
  SECONDARY_POSITION = 1

  begin :validations
    validates :form_answer_id,
              :assessor_id,
              presence: true

    validates :position,
              inclusion: {
                in: [PRIMARY_POSITION, SECONDARY_POSITION]
              },
              presence: true

    validate :award_specific_attributes
    validate :mandatory_fields_for_submitted

    validate do
      validate_rate :rag
      validate_rate :strengths
      validate_rate :verdict
    end
  end

  begin :associations
    belongs_to :assessor
    belongs_to :form_answer
  end

  begin :callbacks
    before_save :clean_document
  end

  store_accessor :document, *Assessment::AppraisalForm.all

  def self.primary
    where(position: PRIMARY_POSITION).first
  end

  def self.secondary
    where(position: SECONDARY_POSITION).first
  end

  private

  def award_specific_attributes
    struct.diff(form_answer.award_type).each do |att|
      if public_send(att).present?
        errors.add(att, "Can not be present for this Award Type")
      end
    end
  end

  def mandatory_fields_for_submitted
    return unless submitted?
    meths.each do |meth|
      if public_send(meth).blank?
        errors.add(meth, "Can not be blank for submitted assessment")
      end
    end
  end

  def submitted?
    submitted_at.present?
  end

  def validate_rate(rate_type)
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
    Assessment::AppraisalForm
  end

  def clean_document
    # erase the assessment if asssessor assignment changed
    return if new_record?
    self.document = nil if assessor_id_changed?
  end
end
