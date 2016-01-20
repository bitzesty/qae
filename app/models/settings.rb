class Settings < ActiveRecord::Base
  self.table_name = "settings"

  has_many :deadlines, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  belongs_to :award_year, inverse_of: :settings

  validates :award_year, presence: true

  after_create :create_deadlines

  def self.current
    Rails.cache.fetch("current_settings", expires_in: 1.minute) do
      AwardYear.current.settings
    end
  end

  def self.current_submission_deadline
    Rails.cache.fetch("submission_end_deadline", expires_in: 1.minute) do
      current.deadlines.submission_end.first
    end
  end

  def self.after_current_submission_deadline?
    deadline = current_submission_deadline.trigger_at
    DateTime.now >= deadline if deadline.present?
  end

  def self.after_shortlisting_stage?
    deadline = Rails.cache.fetch("shortlisted_notifier_notification", expires_in: 1.minute) do
      current.email_notifications.where(kind: "shortlisted_notifier").first
    end

    DateTime.now >= deadline.trigger_at if deadline.present?
  end

  def self.winners_stage?
    deadline = Rails.cache.fetch("winners_notification_notification", expires_in: 1.minute) do
      current.email_notifications.where(kind: "winners_notification").first
    end

    DateTime.now >= deadline.trigger_at if deadline.present?
  end

  def self.unsuccessful_stage?
    deadline = Rails.cache.fetch("unsuccessful_notification_notification", expires_in: 1.minute) do
      current.email_notifications.where(kind: "unsuccessful_notification").first
    end

    DateTime.now >= deadline.trigger_at if deadline.present?
  end

  def self.not_shortlisted_deadline
    Rails.cache.fetch("not_shortlisted_notifier_notification", expires_in: 1.minute) do
      current.email_notifications.not_shortlisted.first.try(:trigger_at)
    end
  end

  def self.not_awarded_deadline
    Rails.cache.fetch("unsuccessful_notification_notification", expires_in: 1.minute) do
      current.email_notifications.not_awarded.first.try(:trigger_at)
    end
  end

  private

  def create_deadlines
    Deadline.enumerized_attributes[:kind].values.each do |kind|
      deadlines.where(kind: kind).first_or_create
    end
  end
end
