class Questionnaire < ActiveRecord::Base
  extend Enumerize

  belongs_to :form_answer

  enumerize :payment_usability_rating, in: { very_easy: 5, easy: 4, no_opinion: 3, difficult: 2, very_difficult: 1 }
  enumerize :security_rating, in: { very_secure: 5, secure: 4, no_opinion: 3, insecure: 2, very_insecure: 1 }
  enumerize :overall_payment_rating, in: { very_good: 5, good: 4, no_opinion: 3, poor: 2, very_poor: 1 }

  validates :overall_payment_rating, :security_rating, :payment_usability_rating, presence: true
end
