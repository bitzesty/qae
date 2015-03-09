class AssessorAssignment < ActiveRecord::Base
  PRIMARY_POSITION = 0
  SECONDARY_POSITION = 1

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

  belongs_to :assessor
  belongs_to :form_answer

  store_accessor :document, *Assessment::AppraisalForm.all

  def self.primary
    where(position: PRIMARY_POSITION).first
  end

  def self.secondary
    where(position: SECONDARY_POSITION).first
  end

  private

  def award_specific_attributes
    Assessment::AppraisalForm.diff(form_answer.award_type).each do |att|
      if public_send(att).present?
        errors.add(att, "Can not be present for this Award Type")
      end
    end
  end

  def mandatory_fields_for_submitted
    return unless submitted?
    att = Assessment::AppraisalForm.meths_for_award_type(form_answer.award_type)
    att.each do |meth|
      if public_send(meth).blank?
        errors.add(meth, "Can not be blank for submitted assessment")
      end
    end
  end

  def submitted?
    submitted_at.present?
  end
end
