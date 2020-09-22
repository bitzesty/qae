class AuditLog < ApplicationRecord
  validates :subject_type, inclusion: { in: %w(Admin Assessor Judge) }, presence: true
  validates :subject_id, presence: true
  validates :action_type, presence: true

  belongs_to :subject, polymorphic: true
  belongs_to :auditable, polymorphic: true
end
