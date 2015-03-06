require 'qae_2014_forms'

class FormAnswer < ActiveRecord::Base
  include PgSearch
  extend Enumerize

  pg_search_scope :basic_search,
                  against: [
                    :urn,
                    :award_type_full_name,
                    :award_year,
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
    "innovation" => "Innovation",
    "trade" => "International Trade",
    "development" => "Sustainable Development",
    "promotion" => "Enterprise promotion"
  }

  enumerize :award_type, in: POSSIBLE_AWARDS, predicates: true

  begin :associations
    belongs_to :user
    belongs_to :account

    has_one :form_basic_eligibility, class_name: 'Eligibility::Basic', dependent: :destroy
    has_one :trade_eligibility, class_name: 'Eligibility::Trade', dependent: :destroy
    has_one :innovation_eligibility, class_name: 'Eligibility::Innovation', dependent: :destroy
    has_one :development_eligibility, class_name: 'Eligibility::Development', dependent: :destroy
    has_one :promotion_eligibility, class_name: 'Eligibility::Promotion', dependent: :destroy
    has_one :audit_certificate, dependent: :destroy

    has_many :form_answer_attachments
    has_many :support_letter_attachments, dependent: :destroy

    has_many :supporters, dependent: :destroy, autosave: true
    has_many :support_letters, dependent: :destroy
    has_many :comments, as: :commentable
    has_many :form_answer_transitions
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
    scope :for_award_type, -> (award_type) { where award_type: award_type }
    scope :for_year, -> (year) { where award_year: year }
  end

  begin :callbacks
    before_validation :check_eligibility, if: :submitted?

    before_save :set_award_year, unless: :award_year?
    before_save :set_urn
    before_save :set_progress
    before_save :build_supporters
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

  def important?
    importance_flag?
  end

  def toggle_importance_flag
    update_attributes(importance_flag: !(self.importance_flag))
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

  private

  def nominee_full_name_from_document
    "#{document['nominee_first_name']} #{document['nominee_last_name']}".strip
  end

  def build_supporters
    if promotion? && submitted?
      if document['supporters'].present?
        document_supporters = JSON.parse(document['supporters'].presence || '[]').map { |answer| JSON.parse(answer) }
        document_supporters.each do |supporter|
          next if supporters.find_by_email(supporter['email'])

          supporter = supporters.build(email: supporter['email'])
        end

        supporters.each do |saved_supporter|
          if document_supporters.none? { |s| s['email'] == saved_supporter.email }
            saved_supporter.mark_for_destruction
          end
        end
      elsif supporters.any?
        supporters.each(&:mark_for_destruction)
      end
    end
  end

  def check_eligibility
    errors.add(:base, "Sorry, you are not eligible") unless eligible?
  end

  def set_urn
    return if urn
    return unless submitted
    return unless award_type

    next_seq = self.class.connection.select_value("SELECT nextval(#{ActiveRecord::Base.sanitize("urn_seq_#{award_type}")})")

    self.urn = "QA#{sprintf('%.4d', next_seq)}/#{award_year.to_s[2..-1]}#{award_type[0].capitalize}"
  end

  def set_account
    self.account = user.account
  end

  def set_award_year
    self.award_year = Date.current.year + 1
  end

  def set_progress
    form = award_form.decorate(answers: HashWithIndifferentAccess.new(document || {}))
    self.fill_progress = form.progress
  end

  def assign_searching_attributes
    self.company_or_nominee_name = company_or_nominee_from_document
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
