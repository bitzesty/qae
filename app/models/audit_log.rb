class AuditLog < ApplicationRecord
  validates :subject_type, inclusion: { in: %w(Admin User Assessor Judge) }, presence: true
  validates :subject_id, presence: true
  validates :action_type, presence: true

  belongs_to :subject, polymorphic: true
  belongs_to :auditable, polymorphic: true

  scope :data_export, -> { AuditLog.where(auditable_type: nil).or(AuditLog.where(action_type: "download_form_answer")) }
end
