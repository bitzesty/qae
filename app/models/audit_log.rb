class AuditLog < ApplicationRecord
  validates :subject_type, inclusion: { in: %w(Admin User Assessor Judge) }, presence: true
  validates :subject_id, presence: true
  validates :action_type, presence: true

  belongs_to :subject, polymorphic: true
  belongs_to :auditable, polymorphic: true

  def to_s
    "On #{date_string} at #{time_string} #{user_string} #{description_for_action_type(action_type)}"
  end

  private

  def date_string
    created_at.in_time_zone("London").strftime("%d/%m/%Y")
  end

  def time_string
    created_at.in_time_zone("London").strftime("%H:%M")
  end

  def description_for_action_type(action_type)
    I18n.translate("audit_logs.action_types.#{action_type}")
  end

  def user_string
    "#{subject.full_name} (#{subject.class.name})"
  end
end
