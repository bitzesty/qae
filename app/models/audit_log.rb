class AuditLog < ApplicationRecord
  validates :subject_type, inclusion: { in: %w(Admin Assessor Judge) }, presence: true
  validates :subject_id, presence: true
  validates :action_type, presence: true

  belongs_to :subject, polymorphic: true
  belongs_to :auditable, polymorphic: true

  ACTION_DESCRIPTIONS = {
    "admin_comment_create": "added an admin comment",
    "admin_comment_destroy": "deleted an admin comment",
    "critical_comment_create": "added a critical comment",
    "critical_comment_destroy": "deleted a critical comment",
    "form_answer_attachment_create": "added an attachment",
    "form_answer_attachment_destroy": "deleted an attachment",
    "primary_appraisal_update": "updated the primary appraisal form",
    "secondary_appraisal_update": "updated the secondary appraisal form",
    "moderated_appraisal_update": "updated the moderated appraisal form",
    "case_summary_update": "updated the case summary",
    "feedback_create": "added feedback",
    "feedback_update": "updated feedback",
    "feedback_submit": "submitted feedback",
    "feedback_unsubmit": "unsubmitted feedback",
    "primary_appraisal_submit": "submitted primary appraisal",
    "primary_appraisal_unsubmit": "unsubmitted primary appraisal",
    "secondary_appraisal_submit": "submitted secondary appraisal",
    "secondary_appraisal_unsubmit": "unsubmitted secondary appraisal",
    "moderated_appraisal_submit": "submitted moderated appraisal",
    "moderated_appraisal_unsubmit": "unsubmitted moderated appraisal",
    "case_summary_submit": "submitted case summary",
    "case_summary_unsubmit": "unsubmitted case summary",
  }

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
    ACTION_DESCRIPTIONS[action_type.to_sym] || action_type
  end

  def user_string
    "#{subject.full_name} (#{subject.class.name})"
  end
end
