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

  belongs_to :assessor
  belongs_to :form_answer

  def self.primary
    where(position: PRIMARY_POSITION)
  end

  def self.secondary
    where(position: SECONDARY_POSITION)
  end
end
