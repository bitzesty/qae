class PreviousWin < ActiveRecord::Base
  CATEGORIES = {
    "Innovation (2 years)" => "innovation2",
    "Innovation (5 years)" => "innovation5",
    "International Trade (3 years)" => "trade3",
    "International Trade (6 years)" => "trade6",
    "Sustainable Development (2 years)" => "development2",
    "Sustainable Development (5 years)" => "development5"
  }

  validates :form_answer_id, presence: true
  validates :category, inclusion: {
    in: CATEGORIES.values
  }, allow_blank: true

  belongs_to :form_answer
end
