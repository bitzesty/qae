class PreviousWin < ActiveRecord::Base
  CATEGORIES = {
    "Innovation" => "innovation",
    "Internation Trade" => "trade",
    "Sustainable Development" => "development"
  }

  validates :form_answer_id, presence: true
  validates :category, inclusion: {
    in: CATEGORIES.values
  }, allow_blank: true

  belongs_to :form_answer

  def self.available_years
    current_year = AwardYear.current.year
    ((current_year - 5)..(current_year - 1)).to_a
  end
end
