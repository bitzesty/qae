class Settings < ActiveRecord::Base
  self.table_name = "settings"

  has_many :deadlines, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  belongs_to :award_year, inverse_of: :settings

  validates :award_year, presence: true, uniqueness: true

  after_create :create_deadlines

  def self.current
    AwardYear.current.settings
  end

  def self.current_submission_deadline
    current.deadlines.submission_end.first
  end

  def self.after_current_submission_deadline?
    return true if Rails.env.development?
    deadline = current_submission_deadline.trigger_at
    DateTime.now >= deadline if deadline.present?
  end

  def self.after_shortlisting_stage?
    deadline = current.email_notifications.where(kind: "shortlisted_notifier").first
    DateTime.now >= deadline.trigger_at if deadline.present?
  end

  private

  def create_deadlines
    Deadline.enumerized_attributes[:kind].values.each do |kind|
      deadlines.where(kind: kind).first_or_create
    end
  end
end
