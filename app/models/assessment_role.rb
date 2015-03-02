class AssessmentRole < ActiveRecord::Base
  POSSIBLE_ROLES = [
    "lead",
    "regular"
  ]

  belongs_to :assessor

  validates :assessor_id, presence: true

  validates :category,
            presence: true,
            inclusion: {
              in: FormAnswer::POSSIBLE_AWARDS
            } # normalization candidate

  validates :role,
            presence: true,
            inclusion: {
              in: POSSIBLE_ROLES
            }
end
