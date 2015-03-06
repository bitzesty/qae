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

  validates :form_answer, presence: true
  validate :award_specific_attributes
  validate :overall_verdict_existence

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

  def sections_attributes
    struct = Assessment::AppraisalForm.struct(form_answer)
    struct.keys.map { |k| ["#{k}_desc".to_sym, "#{k}_rate".to_sym] }.flatten
  end

  def award_specific_attributes
    (Assessment::AppraisalForm.all.map(&:to_sym) - sections_attributes).uniq.each do |att|
      errors.add(att, "Can not be present for this Award Type") if public_send(att).present?
    end
  end

  def overall_verdict_existence
    # TODO - all sections are mandatory for assessors and need to be
     # assigned before overall verdict
  end
end
