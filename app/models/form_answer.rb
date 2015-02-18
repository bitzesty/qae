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

    has_one :form_basic_eligibility, class_name: 'Eligibility::Basic', dependent: :destroy
    has_one :trade_eligibility, class_name: 'Eligibility::Trade', dependent: :destroy
    has_one :innovation_eligibility, class_name: 'Eligibility::Innovation', dependent: :destroy
    has_one :development_eligibility, class_name: 'Eligibility::Development', dependent: :destroy
    has_one :promotion_eligibility, class_name: 'Eligibility::Promotion', dependent: :destroy

    has_many :form_answer_attachments

    has_many :supporters, dependent: :destroy, autosave: true
    has_many :support_letters, through: :supporters
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
  end

  begin :scopes
    scope :for_award_type, -> (award_type) { where award_type: award_type }
  end

  before_create :set_account
  before_save :set_urn
  before_save :set_progress
  before_save :build_supporters
  before_validation :check_eligibility, if: :submitted?

  store_accessor :document
  store_accessor :eligibility
  store_accessor :basic_eligibility

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

  def promotion?
    award_type == 'promotion'
  end

  def important?
    importance_flag?
  end

  def toggle_importance_flag
    update_attributes(importance_flag: !(self.importance_flag))
  end

  private

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

    self.urn = "QA#{sprintf("%.4d", next_seq)}/#{CURRENT_AWARD_YEAR}#{award_type[0].capitalize}"
  end

  def set_account
    self.account = user.account
  end

  def set_progress
    form = award_form.decorate(answers: HashWithIndifferentAccess.new(document || {}))
    self.fill_progress = form.progress
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
        form_answer.public_send("build_#{method}", filter(account.public_send(method).try(:attributes) || {}).merge(account_id: account.id)).save!
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
