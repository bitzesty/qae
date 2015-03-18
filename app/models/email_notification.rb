class EmailNotification < ActiveRecord::Base
  extend Enumerize
  include FormattedTime::DateTimeFor

  date_time_for :trigger_at

  belongs_to :settings

  enumerize :kind, in: %w(reminder_to_submit ep_reminder_support_letters winners_notification winners_reminder_to_submit winners_press_release_comments_request unsuccessfull_notification all_unsuccessfull_feedback shortlisted_notifier shortlisted_audit_certificate_reminder not_shortlisted_notifier)

  validates :kind, :trigger_at, presence: true

  scope :current, -> { where("trigger_at < ?", Time.now.utc).where(sent: false) }
end
