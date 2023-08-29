class Settings < ApplicationRecord
  self.table_name = "settings"

  has_many :deadlines, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  belongs_to :award_year, inverse_of: :settings

  validates :award_year, presence: true

  after_create :create_deadlines

  class << self
    def current
      Rails.cache.fetch("current_settings", expires_in: 1.minute) do
        AwardYear.current.settings
      end
    end

    def current_award_year_switch_date
      Rails.cache.fetch("award_year_switch_deadline", expires_in: 1.minute) do
        current.deadlines.award_year_switch
      end
    end

    def current_award_year_switch_date_or_default_trigger_at
      Rails.cache.fetch("award_year_switch_deadline_or_default_trigger_at", expires_in: 1.minute) do
        if current.deadlines.award_year_switch.trigger_at
          current.deadlines.award_year_switch.trigger_at
        else
          Date.new(current.award_year.year - 1, AwardYear::DEFAULT_FINANCIAL_SWITCH_MONTH, AwardYear::DEFAULT_FINANCIAL_SWITCH_DAY)
        end
      end
    end

    def current_submission_deadline_or_default_trigger_at
      Rails.cache.fetch("award_year_submission_deadline_or_default_trigger_at", expires_in: 1.minute) do
        if current.deadlines.submission_end.first.try(:trigger_at)
          current.deadlines.submission_end.first.trigger_at
        else
          Date.new(current.award_year.year - 1, AwardYear::DEFAULT_FINANCIAL_DEADLINE_MONTH, AwardYear::DEFAULT_FINANCIAL_DEADLINE_DAY)
        end
      end
    end

    def current_submission_start_deadline
      Rails.cache.fetch("submission_start_deadline", expires_in: 1.minute) do
        current.deadlines.submission_start
      end
    end

    %w(innovation trade mobility development).each do |award|
      define_method "current_#{award}_submission_start_deadline" do
        Rails.cache.fetch("#{award}_submission_start_deadline", expires_in: 1.minute) do
          current.deadlines.public_send("#{award}_submission_start")
        end
      end
    end


    def current_submission_start_deadlines
      Rails.cache.fetch("submission_start_deadlines", expires_in: 1.minute) do
        current.deadlines.where(kind: Deadline::SUBMISSION_START_DEADLINES)
      end
    end

    def current_submission_deadline
      Rails.cache.fetch("submission_end_deadline", expires_in: 1.minute) do
        current.deadlines.submission_end.first
      end
    end

    def winner_notification_date
      Rails.cache.fetch("winners_notification", expires_in: 1.minute) do
        current.winners_email_notification.try(:trigger_at).presence
      end
    end

    def current_audit_certificates_deadline
      Rails.cache.fetch("current_audit_certificates_deadline", expires_in: 1.minute) do
        current.deadlines.audit_certificates_deadline
      end
    end

    def current_date_of_submission_deadline
      current_submission_deadline.trigger_at&.to_date
    end

    def after_current_submission_deadline_start?
      current_submission_start_deadlines.any?(&:passed?)
    end

    def all_awards_ready?
      current_submission_start_deadlines.all?(&:passed?)
    end

    def after_current_audit_certificates_deadline?
      deadline = current_audit_certificates_deadline.trigger_at
      DateTime.now >= deadline if deadline
    end

    def after_current_submission_deadline?
      deadline = current_submission_deadline.trigger_at
      DateTime.now >= deadline if deadline.present?
    end

    def after_shortlisting_stage?
      deadline = Rails.cache.fetch("shortlisted_notifier_notification", expires_in: 1.minute) do
        current.email_notifications.where(kind: "shortlisted_notifier").first
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def winners_stage?
      deadline = Rails.cache.fetch("winners_notification_notification", expires_in: 1.minute) do
        current.winners_email_notification
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def unsuccessful_stage?
      deadline = Rails.cache.fetch("unsuccessful_notification_notification", expires_in: 1.minute) do
        current.email_notifications.where(kind: "unsuccessful_notification").first
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def buckingham_palace_invites_stage?(settings = nil)
      settings = current if settings.blank?

      deadline = Rails.cache.fetch("buckingham_palace_invite", expires_in: 1.minute) do
        settings.email_notifications.where(kind: "buckingham_palace_invite").first
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def current_award_year_switched?
      award_year_switch_deadline = current_award_year_switch_date.try(:trigger_at)
      submission_started_deadlines = current_submission_start_deadlines.map(&:trigger_at)

      award_year_switch_deadline.present? &&
      award_year_switch_deadline < Time.zone.now && (
        submission_started_deadlines.any?(&:blank?) ||
        submission_started_deadlines.all? { |d| d > Time.zone.now }
      )
    end

    def not_shortlisted_deadline
      Rails.cache.fetch("not_shortlisted_notifier_notification", expires_in: 1.minute) do
        current.email_notifications.not_shortlisted.first.try(:trigger_at)
      end
    end

    def not_awarded_deadline
      Rails.cache.fetch("unsuccessful_notification_notification", expires_in: 1.minute) do
        current.email_notifications.not_awarded.first.try(:trigger_at)
      end
    end

    def submission_deadline_title
      formatted_datetime = current_submission_deadline.decorate.formatted_trigger_time(false)
      "Submission deadline: #{formatted_datetime}"
    end
  end

  def winners_email_notification
    email_notifications.where(kind: "winners_notification").first
  end

  private

  def create_deadlines
    Deadline.enumerized_attributes[:kind].values.each do |kind|
      deadlines.where(kind: kind).first_or_create
    end
  end
end
