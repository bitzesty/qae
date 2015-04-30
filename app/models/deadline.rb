class Deadline < ActiveRecord::Base
  extend Enumerize
  include FormattedTime::DateTimeFor

  date_time_for :trigger_at

  belongs_to :settings

  AVAILABLE_DEADLINES = [
    "submission_start",
    "submission_end",
    "buckingham_palace_attendees_details",
    "press_release_comments",
    "audit_certificates"
  ]

  enumerize :kind, in: AVAILABLE_DEADLINES, predicates: true
  validates :kind, presence: true

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
end
