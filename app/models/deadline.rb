class Deadline < ActiveRecord::Base
  extend Enumerize
  include Models::FormattedTime::DateTimeFor

  date_time_for :trigger_at

  belongs_to :settings

  enumerize :kind, in: %w(submission_start submission_end buckingham_palace_attendees_details press_release_comments audit_certificates)
  validates :kind, presence: true

  def passed?
    trigger_at && trigger_at < Time.zone.now
  end
end
