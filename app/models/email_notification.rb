class EmailNotification < ApplicationRecord
  extend Enumerize
  include FormattedTime::DateTimeFor

  NOTIFICATION_KINDS = [
                         :award_year_open_notifier,
                         :trade_submission_started_notification,
                         :mobility_submission_started_notification,
                         :development_submission_started_notification,
                         :innovation_submission_started_notification,
                         :reminder_to_submit,
                         :ep_reminder_support_letters,
                         :winners_notification,
                         :winners_press_release_comments_request,
                         :unsuccessful_notification,
                         :unsuccessful_ep_notification,
                         :shortlisted_notifier,
                         :shortlisted_po_sd_notifier,
                         :shortlisted_po_sd_with_actual_figures_notifier,
                         :shortlisted_audit_certificate_reminder,
                         :shortlisted_po_sd_reminder,
                         :not_shortlisted_notifier,
                         :winners_head_of_organisation_notification,
                         :buckingham_palace_invite
                       ]

  date_time_for :trigger_at

  belongs_to :settings, optional: true

  enumerize :kind, in: NOTIFICATION_KINDS

  validates :kind, :trigger_at, presence: true

  after_save :clear_cache
  after_destroy :clear_cache

  scope :current, -> { where("trigger_at < ?", Time.now.utc).where("sent = 'f' OR sent IS NULL") }

  def passed?
    trigger_at && trigger_at < Time.zone.now
  end

  def self.not_shortlisted
    where(kind: "not_shortlisted_notifier")
  end

  def self.not_awarded
    where(kind: ["unsuccessful_notification", "unsuccessful_ep_notification"])
  end

  private

  def clear_cache
    Rails.cache.delete("current_settings")
    Rails.cache.delete("current_award_year")
    Rails.cache.delete("#{kind.value}_notification")
  end
end
