require "concerns/formatted_time/date_time_for"

class Deadline < ApplicationRecord
  extend Enumerize
  include FormattedTime::DateTimeFor

  date_time_for :trigger_at

  belongs_to :settings, optional: true

  AVAILABLE_DEADLINES = [
    "award_year_switch",
    "innovation_submission_start",
    "trade_submission_start",
    "development_submission_start",
    "mobility_submission_start",
    "submission_start",
    "submission_end",
    "buckingham_palace_attendees_details",
    "buckingham_palace_attendees_invite",
    "buckingham_palace_confirm_press_book_notes",
    "buckingham_palace_media_information",
    "buckingham_palace_reception_attendee_information_due_by",
    "audit_certificates",
  ]

  SUBMISSION_START_DEADLINES = [
    "innovation_submission_start",
    "trade_submission_start",
    "development_submission_start",
    "mobility_submission_start",
  ]

  enumerize :kind, in: AVAILABLE_DEADLINES, predicates: true
  validates :kind, presence: true

  after_destroy :clear_cache
  after_save :clear_cache

  class << self
    def with_states_to_trigger(time = DateTime.now)
      where(kind: "submission_end", states_triggered_at: nil).where("trigger_at < ?", time)
    end

    def award_year_switch
      where(kind: "award_year_switch").first
    end

    def submission_end
      where(kind: "submission_end")
    end

    def submission_start
      where(kind: "submission_start").first
    end

    %w[innovation trade mobility development].each do |award|
      define_method :"#{award}_submission_start" do
        where(kind: "#{award}_submission_start").first
      end
    end

    def end_of_embargo
      where(kind: "buckingham_palace_attendees_details").first
    end

    def buckingham_palace_confirm_press_book_notes
      where(kind: "buckingham_palace_confirm_press_book_notes").first
    end

    def buckingham_palace_attendees_invite
      where(kind: "buckingham_palace_attendees_invite").first
    end

    def buckingham_palace_media_information
      where(kind: "buckingham_palace_media_information").first
    end

    def audit_certificates_deadline
      where(kind: "audit_certificates").first
    end
  end

  def passed?
    trigger_at && trigger_at < Time.zone.now
  end

  def strftime(format)
    trigger_at ? trigger_at.strftime(format) : "-"
  end

  private

  def clear_cache
    Rails.cache.delete("current_settings")
    Rails.cache.delete("current_award_year")
    Rails.cache.delete("#{kind.value}_deadline")
    Rails.cache.delete("#{kind}_deadline_#{settings.award_year.year}")

    if SUBMISSION_START_DEADLINES.include?(kind.to_s)
      Rails.cache.delete("submission_start_deadlines")
    end
  end
end
