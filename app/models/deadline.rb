class Deadline < ActiveRecord::Base
  extend Enumerize
  include FormattedTime::DateTimeFor

  date_time_for :trigger_at

  belongs_to :settings

  AVAILABLE_DEADLINES = [
    "submission_start",
    "submission_end",
    "buckingham_palace_attendees_details",
    "buckingham_palace_attendees_invite",
    "buckingham_palace_confirm_press_book_notes",
    "buckingham_palace_media_information",
    "audit_certificates"
  ]

  enumerize :kind, in: AVAILABLE_DEADLINES, predicates: true
  validates :kind, presence: true

  after_save :clear_cache
  after_destroy :clear_cache

  def self.with_states_to_trigger(time = DateTime.now)
    where(kind: "submission_end", states_triggered_at: nil).where("trigger_at < ?", time)
  end

  def self.submission_end
    where(kind: "submission_end")
  end

  def self.submission_start
    where(kind: "submission_start").first
  end

  def passed?
    trigger_at && trigger_at < Time.zone.now
  end

  private

  def clear_cache
    Rails.cache.clear("current_settings")
    Rails.cache.clear("current_award_year")
    Rails.cache.clear("#{kind.value}_deadline")
  end
end
