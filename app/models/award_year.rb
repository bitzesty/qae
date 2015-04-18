class AwardYear < ActiveRecord::Base
  validates :year, presence: true, uniqueness: true

  has_many :form_answers
  has_one :settings, inverse_of: :award_year, autosave: true

  after_create :create_settings

  AVAILABLE_YEARS = [2016, 2017, 2018, 2019]

  # +1 here is to match URN number of assosiated forms
  def self.mock_current_year?
    Rails.env.test?
  end

  def self.current
    return where(year: 2016).first_or_create if mock_current_year?

    now = DateTime.now
    deadline = AwardYear.where(year: now.year + 1).first_or_create.settings.deadlines.submission_start.try(:trigger_at)

    deadline ||= Date.new(now.year, 4, 21)
    if now >= deadline.to_datetime
      y = now.year + 1
    else
      y = now.year
    end

    where(year: y).first_or_create
  end

  def self.closed
    for_year(Date.current.year).first_or_create
  end

  def self.for_year(year)
    where(year: year)
  end

  def user_creation_range
    # Assumes that:
    # 1. User is created in the same calendar year as the submission period is open
    # 2. Submissions period can't cover 2 calendar years
    (DateTime.new(year - 1)..DateTime.new(year - 1, 12).end_of_month)
  end

  def self.award_holder_range
    "#{AwardYear.current.year - 5}-#{AwardYear.current.year - 1}"
  end

  def self.start_trading_moment(kind)
    if ["trade"].include?(kind)
      i = 4
    else
      i = 3
    end
    Date.new(AwardYear.current.year - i, 10, 1).strftime("%d/%m/%Y")
  end

  private

  def create_settings
    self.settings = Settings.create!(award_year: self) unless settings
  end
end
