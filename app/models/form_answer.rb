require_relative '../../forms/award_years/v2018/qae_forms'
require_relative '../../forms/award_years/v2019/qae_forms'
require_relative '../../forms/award_years/v2020/qae_forms'
require_relative '../../forms/award_years/v2021/qae_forms'
require_relative '../../forms/award_years/v2022/qae_forms'
require_relative '../../forms/award_years/v2023/qae_forms'
require_relative '../../forms/award_years/v2024/qae_forms'

class FormAnswer < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries
  include PgSearch::Model
  extend Enumerize
  include FormAnswerStatesHelper
  include FormAnswerAppraisalFormHelpers
  include RegionHelper

  has_paper_trail

  attr_accessor :current_step, :validator_errors, :steps_with_errors, :current_non_js_step

  pg_search_scope :basic_search,
                  against: [
                    :urn,
                    :award_type_full_name,
                    :company_or_nominee_name,
                    :nominee_full_name,
                    :user_full_name,
                    :user_email
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
    "mobility", # Promoting Opportunity Award
    "promotion" # Enterprise Promotion Award
  ]

  BUSINESS_AWARD_TYPES = %w(trade innovation development mobility)

  AWARD_TYPE_FULL_NAMES = {
    "trade" => "International Trade",
    "innovation" => "Innovation",
    "development" => "Sustainable Development",
    "mobility" => "Promoting Opportunity",
    "promotion" => "Enterprise Promotion"
  }
  CURRENT_AWARD_TYPE_FULL_NAMES = AWARD_TYPE_FULL_NAMES.reject do |k, _|
    k == "promotion"
  end

  FINANCIAL_STEPS = {
    ..2023 => {
      "trade" => 3,
      "innovation" => 3,
      "development" => 3,
      "mobility" => 3,
      "promotion" => 3,
    },
    2024.. => {
      "trade" => 4,
      "innovation" => 4,
      "development" => 4,
      "mobility" => 4,
    }
  }

  enumerize :award_type, in: POSSIBLE_AWARDS, predicates: true

  mount_uploader :pdf_version, FormAnswerPdfVersionUploader

  begin :associations
    belongs_to :user, optional: true
    belongs_to :account, optional: true
    belongs_to :award_year, optional: true
    belongs_to :company_details_editable, polymorphic: true, optional: true

    has_one :form_basic_eligibility, class_name: 'Eligibility::Basic', dependent: :destroy
    has_one :trade_eligibility, class_name: 'Eligibility::Trade', dependent: :destroy
    has_one :innovation_eligibility, class_name: 'Eligibility::Innovation', dependent: :destroy
    has_one :development_eligibility, class_name: 'Eligibility::Development', dependent: :destroy
    has_one :mobility_eligibility, class_name: 'Eligibility::Mobility', dependent: :destroy
    has_one :promotion_eligibility, class_name: 'Eligibility::Promotion', dependent: :destroy
    has_one :audit_certificate, dependent: :destroy
    has_one :feedback, dependent: :destroy
    has_one :press_summary, dependent: :destroy
    has_one :draft_note, as: :notable, dependent: :destroy
    has_one :palace_invite, dependent: :destroy
    has_one :form_answer_progress, dependent: :destroy
    has_one :shortlisted_documents_wrapper, dependent: :destroy

    # PDF Hard Copies
    #
    has_one :case_summary_hard_copy_pdf, dependent: :destroy
    has_one :feedback_hard_copy_pdf, dependent: :destroy

    belongs_to :primary_assessor, optional: true, class_name: "Assessor", foreign_key: :primary_assessor_id
    belongs_to :secondary_assessor, optional: true, class_name: "Assessor", foreign_key: :secondary_assessor_id
    has_many :form_answer_attachments, dependent: :destroy
    has_many :support_letter_attachments, dependent: :destroy
    has_many :commercial_figures_files, dependent: :destroy
    has_many :vat_returns_files, dependent: :destroy

    has_many :audit_logs, as: :auditable
    has_many :supporters, dependent: :destroy, autosave: true
    has_many :support_letters, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :form_answer_transitions, autosave: false
    has_many :assessor_assignments, dependent: :destroy
    has_many :lead_or_primary_assessor_assignments,
             -> { where.not(submitted_at: nil)
                       .where(position: [3, 4])
                       .order(position: :desc) },
             class_name: "AssessorAssignment",
             foreign_key: :form_answer_id
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
    validates :sic_code, format: { with: SicCode::REGEX }, allow_nil: true, allow_blank: true
    validate :validate_answers
  end

  begin :scopes
    scope :for_award_type, -> (award_type) { where(award_type: award_type) }
    scope :for_year, -> (year) { joins(:award_year).where(award_years: { year: year }) }
    scope :shortlisted, -> { where(state: %w(reserved recommended)) }
    scope :not_shortlisted, -> { where(state: "not_recommended") }
    scope :winners, -> { where(state: "awarded") }
    scope :unsuccessful_applications, -> { submitted.where("state not in ('awarded', 'withdrawn')") }
    scope :submitted, -> { where.not(submitted_at: nil) }
    scope :positive, -> { where(state: FormAnswerStateMachine::POSITIVE_STATES) }
    scope :at_post_submission_stage, -> { where(state: FormAnswerStateMachine::POST_SUBMISSION_STATES) }
    scope :not_positive, -> { where(state: FormAnswerStateMachine::NOT_POSITIVE_STATES) }
    scope :business, -> { where(award_type: BUSINESS_AWARD_TYPES) }
    scope :promotion, -> { where(award_type: "promotion") }
    scope :in_progress, -> { where(state: ["eligibility_in_progress", "application_in_progress"]) }
    scope :without_product_figures, ->(condition) {
      where(%Q{(#{FormAnswer.table_name}.document::JSONB->>'product_estimated_figures')::boolean is #{condition}})
    }
    scope :with_estimated_figures_provided, -> { without_product_figures(true) }
    scope :with_actual_figures_provided, -> { without_product_figures(false) }
    scope :by_registration_numbers, ->(*numbers) {
      query = numbers.join("|")

      where(
        %Q{#{table_name}.document::JSONB @? '$.registration_number ? (@.type() == "string" && @ like_regex "[[:<:]](#{query})[[:>:]]" flag "i")'}
      )
    }

    scope :past, -> {
      where(award_year_id: AwardYear.past.pluck(:id)).order("award_type")
    }

    scope :hard_copy_generated, -> (mode) {
      submitted.where("#{mode}_hard_copy_generated" => true)
    }

    scope :with_comments_counters, -> {
      select("form_answers.*, COUNT(DISTINCT(comments.id)) AS comments_count, COUNT(DISTINCT(flagged_admin_comments.id)) AS flagged_admin_comments_count, COUNT(DISTINCT(flagged_critical_comments.id)) AS flagged_critical_comments_count")
        .joins("LEFT OUTER JOIN comments ON comments.commentable_id = form_answers.id AND comments.commentable_type = 'FormAnswer'")
        .joins("LEFT OUTER JOIN comments AS flagged_admin_comments ON flagged_admin_comments.commentable_id = form_answers.id AND flagged_admin_comments.commentable_type = 'FormAnswer' AND flagged_admin_comments.flagged IS true AND flagged_admin_comments.section = 0")
        .joins("LEFT OUTER JOIN comments AS flagged_critical_comments ON flagged_critical_comments.commentable_id = form_answers.id AND flagged_critical_comments.commentable_type = 'FormAnswer' AND flagged_critical_comments.flagged IS true AND flagged_critical_comments.section = 1")
    }

    scope :primary_and_secondary_appraisals_are_not_match, -> {
      where("discrepancies_between_primary_and_secondary_appraisals::text <> '{}'::text")
    }

    scope :require_vocf, -> { where(award_type: %w[trade innovation]) }
    scope :vocf_free, -> { where(award_type: %w[mobility development]) }
    scope :provided_estimates, -> { where("document #>> '{product_estimated_figures}' = 'yes'") }
  end

  begin :callbacks
    before_save :set_award_year, unless: :award_year
    before_save :set_urn
    before_save :set_progress
    before_save :set_region
    before_save :assign_searching_attributes

    before_create :set_account
    before_create :set_user_info
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


  # FormAnswer#award_form
  # fetches relevant award form for the application's award year if available
  # else uses form for the current award year
  #
  # for the test environment uses current or previous year
  #
  # The older year's awards have different award types which was removed from the recent years
  # e.g. promotion.
  # So if the form_class of requested year doesn't implement requested award type, it will fallback to oldest award year
  #
  def award_form
    if award_year.present?
      form_class = if self.class.const_defined?(award_form_class_name(award_year.year))
        self.class.const_get(award_form_class_name(award_year.year))
      elsif self.class.const_defined?(award_form_class_name(AwardYear.current.year))
        self.class.const_get(award_form_class_name(AwardYear.current.year))
      elsif Rails.env.test?
        year = Date.current.year
        if self.class.const_defined?(award_form_class_name(year + 1))
          self.class.const_get(award_form_class_name(year + 1))
        elsif self.class.const_defined?(award_form_class_name(year))
          self.class.const_get(award_form_class_name(year))
        end
      else
        raise ArgumentError, "Can not find award form for the application"
      end

      if award_type.present?
        unless form_class.respond_to?(award_type)
          form_class = self.class.const_get(award_form_class_name(2018))
        end
        form_class.public_send(award_type)
      end
    end
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

  def in_positive_state?
    FormAnswerStateMachine::POSITIVE_STATES.map(&:to_s).include?(state)
  end

  def from_previous_years?
    award_year.year < AwardYear.current.year
  end

  def document
    super || {}
  end

  def head_of_business
    head_of_business = document["head_of_business_first_name"].to_s
    head_of_business += " "
    head_of_business += document["head_of_business_last_name"].to_s
  end

  def company_or_nominee_from_document
    comp_attr = promotion? ? 'organization_name' : 'company_name'
    name = document[comp_attr]
    name = nominee_full_name_from_document if promotion? && name.blank?
    name = name.try(:strip)
    name.presence
  end

  def nominee_full_name_from_document
    "#{document['nominee_info_first_name']} #{document['nominee_info_last_name']}".strip
  end

  def fill_progress_in_percents
    ((fill_progress || 0) * 100).floor.to_s + "%"
  end

  def performance_years
    case award_type
    when "innovation"
      document["innovation_performance_years"]
    end
  end

  def whodunnit
    PaperTrail.request.whodunnit
  end

  def submission_end_date
    award_year.settings
              .deadlines
              .submission_end
              .last
              .try(:trigger_at)
  end

  def submission_ended?
    submission_end_date.present? && (Time.zone.now > submission_end_date)
  end

  def version_before_deadline
    paper_trail.version_at(submission_end_date - 1.minute)
  end

  def original_form_answer
    submission_ended? ? version_before_deadline : self
  end

  def shortlisted?
    state == "reserved" || state == "recommended"
  end

  def business?
    BUSINESS_AWARD_TYPES.include?(award_type)
  end

  def financial_step
    h = FINANCIAL_STEPS.select { |y| y === self.award_year.year }
    h.values[0][self.award_type] - 1
  end

  #
  # Hard Copy PDF generators - begin
  #

  def generate_pdf_version!
    HardCopyGenerators::FormDataGenerator.new(self).run
  end

  def generate_pdf_version_from_latest_doc!
    HardCopyGenerators::FormDataGenerator.new(self, true).run
  end

  def generate_case_summary_hard_copy_pdf!
    HardCopyGenerators::CaseSummaryGenerator.new(self).run
  end

  def generate_feedback_hard_copy_pdf!
    HardCopyGenerators::FeedbackGenerator.new(self).run
  end

  def hard_copy_ready_for?(mode)
    send("#{mode}_hard_copy_generated?") &&
    send("#{mode}_hard_copy_pdf").present? &&
    send("#{mode}_hard_copy_pdf").file.present?
  end

  #
  # Hard Copy PDF generators - end
  #

  def unsuccessful_app?
    !awarded? && !withdrawn?
  end

  def collaborators
    if account
      account.collaborators_with(user)
    else
      User.none
    end
  end

  def has_more_than_one_contributor?
    collaborators.count > 1
  end

  def palace_invite_submitted
    palace_invite.try(:submitted) ? 'Yes' : 'No'
  end

  def submitted?
    submitted_at.present?
  end

  # SIC code helpers
  #
  def sic_code=(code)
    if code.present?
      document["sic_code"] = code
    end
  end

  def sic_code
    document["sic_code"]
  end

  def previous_wins
    if document["applied_for_queen_awards_details"]
      document["applied_for_queen_awards_details"].select { |a| a["outcome"] == "won" }
    elsif document["queen_award_holder_details"]
      document["queen_award_holder_details"]
    else
      []
    end
  end

  def won_international_trade_award_last_year?
    condition = document
      .fetch("applied_for_queen_awards_details", [])
      .detect do |a|
        a["category"] == "international_trade" &&
        a["outcome"] == "won" &&
        a["year"].to_i >= (AwardYear.current.year - 1)
      end

    !!condition
  end

  def agree_sharing_of_details_with_lieutenancies?
    user.present? && user.agree_sharing_of_details_with_lieutenancies ? "Yes" : "No"
  end

  def requires_vocf?
    return false if !business?
    return true if award_year && award_year.before_vocf_switch?

    %w(trade innovation).include?(award_type)
  end

  def financial_year_changeable?
    key = :most_recent_financial_year
    selected = %i[most_recent_financial_year financial_year_date_day financial_year_date_month]
    self.award_form
        .questions_by_key[key]
        &.decorate(answers: HashWithIndifferentAccess.new(document || {}).slice(*selected))
        &.year_changeable?
  end

  def provided_estimates?
    document["product_estimated_figures"] == "yes"
  end

  def shortlisted_documents_submitted?
    shortlisted_documents_wrapper&.submitted?
  end

  def other_applications_from_same_entity
    content = self.document.dig("registration_number")
    extracted_numbers = ::CompanyRegistrationNumber.extract_from(content)

    return [] if extracted_numbers.empty?

    self.class.submitted
              .where.not(id: self.id)
              .by_registration_numbers(*extracted_numbers)
              .joins(:award_year)
              .order("award_years.year DESC")
  end

  private

  def nominator_full_name_from_document
    "#{document['user_info_first_name']} #{document['user_info_last_name']}".strip
  end

  def nominator_email_from_document
    document["personal_email"]
  end

  def set_urn
    builder = UrnBuilder.new(self)
    builder.assign
  end

  def set_account
    self.account = user.account
  end

  def set_award_year
    self.award_year = AwardYear.current
  end

  def set_progress
    #TODO: move this logic to it's specific class when you create one class per document type.
    if award_type == "promotion"
      questions_that_dont_count = []
    else
      questions_that_dont_count = if award_year.year <= 2019
        [:company_name]
      else
        [:company_name, :queen_award_holder]
      end
    end

    progress_hash = HashWithIndifferentAccess.new(document || {}).except(*questions_that_dont_count)
    form = award_form.decorate(answers: progress_hash)
    self.fill_progress = form.required_visible_questions_filled.to_f / (form.required_visible_questions_total - questions_that_dont_count.count)

    unless new_record?
      progress = (form_answer_progress || build_form_answer_progress)
      progress.assign_sections(form)
      progress.save
    end
    true
  end

  def set_region
    county = document["organization_address_county"]
    document["organization_address_region"] = lookup_region_for_county(county.to_sym) unless county.nil?
  end

  def assign_searching_attributes
    unless submitted_and_after_the_deadline?
      self.company_or_nominee_name = company_or_nominee_from_document
    end

    self.nominee_full_name = nominee_full_name_from_document
    self.nominator_full_name = nominator_full_name_from_document
    self.nominator_email = nominator_email_from_document
    self.award_type_full_name = AWARD_TYPE_FULL_NAMES[award_type]
  end

  def set_user_info
    if user.present?
      self.user_full_name ||= user.full_name
      self.user_email ||= user.email
    end
  end

  def validate_answers
    if current_non_js_step.present? || (submitted? && (current_step || (submitted_at_changed? && submitted_at_was.nil?)))

      validator = FormAnswerValidator.new(self)

      unless validator.valid?

        if Rails.env.test?
          # Better output in Test env
          # so that devs can easily detect the reasons of issues!
          errors.add(:base, "Answers invalid! Errors: #{validator.errors.inspect}")
        else
          errors.add(:base, "Answers invalid")
        end

        self.validator_errors = validator.errors
      end
    end
  end

  def award_form_class_name(year)
    "::AwardYears::V#{year}::QaeForms"
  end

  def self.transition_class
    FormAnswerTransition
  end

  def self.initial_state
    FormAnswerStateMachine.initial_state
  end
end
