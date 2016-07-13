class AuditLog < ActiveRecord::Base
  validates :subject_type, inclusion: { in: %w(Admin Assessor) }, presence: true
  validates :subject_id, presence: true
  validates :action_type, presence: true

  belongs_to :subject, polymorphic: true
  belongs_to :auditable, polymorphic: true
end
