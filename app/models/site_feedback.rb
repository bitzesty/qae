class SiteFeedback < ApplicationRecord
  extend Enumerize

  enumerize :rating, in: { very_satisfied: 5,
                           satisfied: 4,
                           neither_satisfied_or_dissatisfied: 3,
                           dissatisfied: 2,
                           very_dissatisfied: 1 }

  validates :rating, presence: true
end
