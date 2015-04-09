require 'qae_2014_forms'

class FormAnswer < ActiveRecord::Base
  include PgSearch
  extend Enumerize

  pg_search_scope :basic_search,
                  against: [
                    :urn,
                    :award_type_full_name,
                    :company_or_nominee_name,
                    :nominee_full_name,
                    :user_full_name
                  ],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  POSSIBLE_AWARDS = [
    "trade", # International Trade Award
    "innovation", # Innovation Award
    "development", # Sustainable Development Award
    "promotion" # Enterprise promotion Award
  ]

  AWARD_TYPE_FULL_NAMES = {
    "trade" => "International Trade",
    "innovation" => "Innovation",
    "development" => "Sustainable Development",
    "promotion" => "Enterprise promotion"
  }

  enumerize :award_type, in: POSSIBLE_AWARDS, predicates: true

  begin :associations
    belongs_to :user
    belongs_to :account
    belongs_to :award_year

    has_one :form_basic_eligibility, class_name: 'Eligibility::Basic', dependent: :destroy
    has_one :trade_eligibility, class_name: 'Eligibility::Trade', dependent: :destroy
    has_one :innovation_eligibility, class_name: 'Eligibility::Innovation', dependent: :destroy
    has_one :development_eligibility, class_name: 'Eligibility::Development', dependent: :destroy
    has_one :promotion_eligibility, class_name: 'Eligibility::Promotion', dependent: :destroy
    has_one :audit_certificate, dependent: :destroy
    has_one :feedback, dependent: :destroy
    has_one :press_summary, dependent: :destroy
    has_one :draft_note, as: :notable, dependent: :destroy
    has_one :company_detail, dependent: :destroy
    has_one :palace_invite, dependent: :destroy

    has_many :form_answer_attachments, dependent: :destroy
    has_many :support_letter_attachments, dependent: :destroy

    has_many :supporters, dependent: :destroy, autosave: true
    has_many :support_letters, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :form_answer_transitions
    has_many :assessor_assignments, dependent: :destroy
    has_many :previous_wins, dependent: :destroy
    has_many :assessors, through: :assessor_assignments do
      def primary
        where(assessor_assignments:
          {
            position: 0
          }
        ).first
      end

      def secondary
        where(assessor_assignments:
          {
            position: 1
          }
        ).first
      end
    end
  end

  begin :validations
    validates :user, presence: true
    validates :award_type, presence: true,
                           inclusion: {
                             in: POSSIBLE_AWARDS
                           }
    validates_uniqueness_of :urn, allow_nil: true, allow_blank: true
    validates :sic_code, format: { with: SICCode::REGEX }, allow_nil: true
  end

  begin :scopes
    scope :for_award_type, -> (award_type) { where(award_type: award_type) }
    scope :for_year, -> (year) { joins(:award_year).where(award_years: { year: year }) }
    scope :shortlisted_with_no_certificate, -> { where("1 = 0") }
    scope :winners, -> { where("1 = 0") }
    scope :unsuccessful, -> { where(state: %w(not_recommended reserved)) }
  end

  begin :callbacks
    before_save :set_award_year, unless: :award_year
    before_save :set_urn
    before_save :set_progress
    before_save :assign_searching_attributes

    before_create :set_account
    before_create :set_user_full_name
  end

  store_accessor :document
  store_accessor :financial_data

  begin :state_machine
    delegate :current_state, :trigger!, :available_events, to: :state_machine
    delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
      to: :state_machine

    def state_machine
      @state_machine ||= FormAnswerStateMachine.new(self, transition_class: FormAnswerTransition)
    end
  end

  accepts_nested_attributes_for :previous_wins,
                                allow_destroy: true,
                                reject_if: proc { |attrs|
                                  attrs[:year].blank? && attrs[:category].blank?
                                }

  def award_form
    QAE2014Forms.public_send(award_type) if award_type.present?
  end

  def eligibility
    public_send("#{award_type}_eligibility")
  end

  def eligibility_class
    "Eligibility::#{award_type.capitalize}".constantize
  end

  def eligible?
    eligibility && eligibility.eligible? && (promotion? || (form_basic_eligibility && form_basic_eligibility.eligible?))
  end

  def document
    super || {}
  end

  def company_or_nominee_from_document
    comp_attr = promotion? ? 'organization_name' : 'company_name'
    name = document[comp_attr]
    name = nominee_full_name_from_document if promotion? && name.blank?
    name = name.try(:strip)
    name.presence
  end

  def fill_progress_in_percents
    ((fill_progress || 0) * 100).round.to_s + "%"
  end

  def performance_years
    case award_type
    when "innovation"
      document["innovation_performance_years"]
    end
  end

  def submitted_and_after_the_deadline?
    submitted? && Settings.after_current_submission_deadline?
  end

  private

  def nominee_full_name_from_document
    "#{document['nominee_info_first_name']} #{document['nominee_info_last_name']}".strip
  end

  def set_urn
    return if urn
    return unless submitted
    return unless award_type

    next_seq = self.class.connection.select_value("SELECT nextval(#{ActiveRecord::Base.sanitize("urn_seq_#{award_type}")})")

    generated_urn = "QA#{sprintf('%.4d', next_seq)}/"
    generated_urn += "#{award_year.year.to_s[2..-1]}#{award_type[0].capitalize}"

    self.urn = generated_urn
  end

  def set_account
    self.account = user.account
  end

  def set_award_year
    self.award_year = AwardYear.current
  end

  def set_progress
    form = award_form.decorate(answers: HashWithIndifferentAccess.new(document || {}))
    self.fill_progress = form.progress
  end

  def assign_searching_attributes
    unless submitted_and_after_the_deadline?
      self.company_or_nominee_name = company_or_nominee_from_document
    end
    self.nominee_full_name = nominee_full_name_from_document
    self.award_type_full_name = AWARD_TYPE_FULL_NAMES[award_type]
  end

  def set_user_full_name
    self.user_full_name ||= user.full_name if user.present?
  end

  class AwardEligibilityBuilder
    attr_reader :form_answer, :account

    def initialize(form_answer)
      @form_answer = form_answer
      @account = form_answer.user.account
    end

    def eligibility
      method = "#{form_answer.award_type}_eligibility"

      unless form_answer.public_send(method)
        form_answer.public_send("build_#{method}", account_id: account.id).save!
      end

      form_answer.public_send(method)
    end

    def basic_eligibility
      @basic_eligibility ||= begin
        return nil if form_answer.promotion?

        if form_answer.form_basic_eligibility.try(:persisted?)
          form_answer.form_basic_eligibility
        else
          form_answer.build_form_basic_eligibility(filter(account.basic_eligibility.try(:attributes) || {}).merge(account_id: account.id)).save!
          form_answer.form_basic_eligibility
        end
      end
    end

    private

    def filter(params)
      params.except("id", "created_at", "updated_at")
    end
  end
end
