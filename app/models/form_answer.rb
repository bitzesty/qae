require 'qae_2014_forms'

class FormAnswer < ActiveRecord::Base
  POSSIBLE_AWARDS = [
    "trade", # International Trade Award
    "innovation", # Innovation Award
    "development", # Sustainable Development Award
    "promotion" # Enterprise promotion Award
  ]

  CURRENT_AWARD_YEAR = '14'

  begin :associations
    belongs_to :user
    belongs_to :account
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
    scope :order_by_current_year_urn, -> do
      where("urn ~ '^QA\\d{4}\\/#{CURRENT_AWARD_YEAR}\\w{1}$'").order(:urn)
    end
  end

  before_create :set_account
  before_create :set_urn

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

  private

  def set_urn
    previous_urn_num = 0

    if previous_form = self.class.order_by_current_year_urn.last
      previous_urn = previous_form.urn
      previous_urn_num = previous_urn.split('/')[0].delete('QA')
    end

    self.urn = "QA#{sprintf("%.4d", (previous_urn_num.to_i + 1))}/#{CURRENT_AWARD_YEAR}#{award_type[0].capitalize}"
  end

  def set_account
    self.account = user.account
  end
end
