class AwardYear < ActiveRecord::Base
  validates :year, presence: true, uniqueness: true

  has_many :form_answers
  has_one :settings, inverse_of: :award_year, autosave: true

  after_create :create_settings

  AVAILABLE_YEARS = [2016, 2017, 2018, 2019]

  # +1 here is to match URN number of assosiated forms
  def self.current
    for_year(Date.current.year + 1).first_or_create
  end

  def self.closed
    for_year(Date.current.year).first_or_create
  end

  def self.for_year(year)
    where(year: year)
  end

  private

  def create_settings
    self.settings = Settings.create!(award_year: self) unless settings
  end
end
