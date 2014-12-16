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

    has_one :basic_eligibility, class_name: 'Eligibility::Basic', dependent: :destroy
    has_one :trade_eligibility, class_name: 'Eligibility::Trade', dependent: :destroy
    has_one :innovation_eligibility, class_name: 'Eligibility::Innovation', dependent: :destroy
    has_one :development_eligibility, class_name: 'Eligibility::Development', dependent: :destroy
  end

  begin :validations
    validates :user, presence: true
    validates :award_type, presence: true,
                           inclusion: {
                             in: POSSIBLE_AWARDS
                           }
    validates_uniqueness_of :urn, allow_nil: true, allow_blank: true
  end

  begin :scopes
    scope :for_award_type, -> (award_type) { where award_type: award_type }
    scope :for_user, -> (user) { where user: user }
    scope :for_account, -> (account) { where account: account }
  end

  before_create :set_account
  before_save :set_urn
  before_validation :check_eligibility, if: :submitted

  store_accessor :document
  store_accessor :eligibility
  store_accessor :basic_eligibility

  attr_accessor :submitted

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

  def eligibility
    public_send("#{award_type}_eligibility")
  end

  def eligibility_class
    "Eligibility::#{award_type.capitalize}".constantize
  end

  def eligible?
    eligibility && eligibility.eligible? && basic_eligibility && basic_eligibility.eligible?
  end

  private

  def check_eligibility
    errors.add(:base, "Sorry, you are not eligible") unless eligible?
  end

  def set_urn
    return if urn
    return unless submitted
    return unless award_type

    next_seq = self.class.connection.select_value("SELECT nextval(#{ActiveRecord::Base.sanitize("urn_seq_#{award_type}")})")

    self.urn = "QA#{sprintf("%.4d", next_seq)}/#{CURRENT_AWARD_YEAR}#{award_type[0].capitalize}"
  end

  def set_account
    self.account = user.account
  end

  class AwardEligibilityBuilder
    attr_reader :form_answer, :user

    def initialize(form_answer)
      @form_answer = form_answer
      @user = form_answer.user
    end

    def eligibility
      method = "#{form_answer.award_type}_eligibility"

      unless form_answer.public_send(method)
        form_answer.public_send("build_#{method}", filter(user.public_send(method).try(:attributes) || {})).save!
      end

      form_answer.public_send(method)
    end

    def basic_eligibility
      @basic_eligibility ||= begin
        if form_answer.basic_eligibility.try(:persisted?)
          form_answer.basic_eligibility
        else
          form_answer.build_basic_eligibility(filter(user.basic_eligibility.try(:attributes) || {})).save!
          form_answer.basic_eligibility
        end
      end
    end

    private

    def filter(params)
      params.except("id", "created_at", "updated_at")
    end
  end
end
