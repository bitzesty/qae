require 'qae_2014_forms'

class FormAnswer < ActiveRecord::Base
  POSSIBLE_AWARDS = [
    "trade", # International Trade Award
    "innovation", # Innovation Award
    "development", # Sustainable Development Award
    "promotion" # Enterprise promotion Award
  ]

  begin :associations
    belongs_to :user
  end

  begin :validations
    validates :user, presence: true
    validates :award_type, presence: true,
                           inclusion: {
                             in: POSSIBLE_AWARDS
                           }
  end

  begin :scopes
    scope :for_award_type, -> (award_type) { where award_type: award_type }
  end

  store_accessor :document

  def award_form
    case award_type
    when "trade"
      QAE2014Forms.trade
    when "innovation"
      QAE2014Forms.innovation
    when "development"
      QAE2014Forms.development
    when "promotion" 
      QAE2014Forms.promotion
    end
  end
end
