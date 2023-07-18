class AuditLog < ApplicationRecord
  validates :subject_type, inclusion: { in: %w(Admin User Assessor Judge) }, presence: true
  validates :subject_id, presence: true
  validates :action_type, presence: true

  belongs_to :subject, polymorphic: true, optional: true
  belongs_to :auditable, polymorphic: true, optional: true

  scope :data_export, -> { where(auditable_type: nil).or(where(action_type: "download_form_answer")) }
  scope :data_update, -> { where(auditable_type: "FormAnswer").where("action_type != 'download_form_answer'") }

  def subject
    subject_type.constantize.unscoped.where(id: subject_id).first
  rescue NameError
    nil
  end
end
