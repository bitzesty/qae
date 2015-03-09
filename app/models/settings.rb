class Settings < ActiveRecord::Base
  self.table_name = "settings"

  AVAILABLE_YEARS = [2015, 2016, 2017, 2018]

  has_many :deadlines, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  after_create :create_deadlines

  def self.for_year(year)
    where(year: year).first_or_create
  end

  def self.current
    for_year(Date.current.year)
  end

  private

  def create_deadlines
    Deadline.enumerized_attributes[:kind].values.each do |kind|
      deadlines.where(kind: kind).first_or_create
    end
  end
end
