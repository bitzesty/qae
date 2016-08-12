class AwardYear < ActiveRecord::Base
  validates :year, presence: true

  has_many :form_answers
  has_many :assessor_assignments
  has_many :feedbacks
  has_one :settings, inverse_of: :award_year, autosave: true

  has_many :aggregated_case_summary_hard_copies, -> { where(type_of_report: "case_summary") },
                                                    class_name: "AggregatedAwardYearPdf",
                                                    dependent: :destroy

  has_many :aggregated_feedback_hard_copies, -> { where(type_of_report: "feedback") },
                                                 class_name: "AggregatedAwardYearPdf",
                                                 dependent: :destroy

  after_create :create_settings

  AVAILABLE_YEARS = [2016, 2017, 2018, 2019, 2020]

  scope :past, -> {
    where(year: past_years)
  }

  #
  # Update me every year!
  #
  CURRENT_YEAR_AWARDS = [
    "trade", # International Trade Award
    "innovation", # Innovation Award
    "development", # Sustainable Development Award
    "mobility", # Promoting Opportunity Award
  ]

  def current?
    self.year == self.class.current.year
  end

  #
  # Setting up helper methods for hard-copy pdfs
  # per Award category and PDF type (Case Summary or Feedback)
  #
  FormAnswer::POSSIBLE_AWARDS.each do |award_category|
    AggregatedAwardYearPdf::TYPES.each do |pdf_type|
      define_method("#{pdf_type}_#{award_category}_hard_copy_pdf") do
        send("aggregated_#{pdf_type}_hard_copies").find_by(award_category: award_category)
      end
    end
  end

  def form_data_generation_can_be_started?
    Settings.after_current_submission_deadline? &&
    form_data_hard_copies_state.nil?
  end

  def case_summary_generation_can_be_started?
    Settings.winners_stage? &&
    case_summary_hard_copies_state.nil?
  end

  def feedback_generation_can_be_started?
    Settings.unsuccessful_stage? &&
    feedback_hard_copies_state.nil?
  end

  def aggregated_case_summary_generation_can_be_started?
    Settings.winners_stage? &&
    aggregated_case_summary_hard_copy_state.nil?
  end

  def aggregated_feedback_generation_can_be_started?
    Settings.unsuccessful_stage? &&
    aggregated_feedback_hard_copy_state.nil?
  end

  def aggregated_hard_copies_completed?(type)
    CURRENT_YEAR_AWARDS.all? do |award_category|
      copy_record = send("#{type}_#{award_category}_hard_copy_pdf")
      copy_record.present? && copy_record.file.present?
    end
  end

  def check_aggregated_hard_copy_pdf_generation_status!(type)
    if aggregated_hard_copies_completed?(type)
      update_column("aggregated_#{type}_hard_copy_state", "completed")
    else
      Raven.capture_exception(
        "[#{ENV['MAILER_HOST']} | HARD COPY GENERATION] ERROR with generation of aggregated #{type} hard copy for #{year}!"
      )

      false
    end
  end

  def check_hard_copy_pdf_generation_status!(type)
    scope = send("hard_copy_#{type}_scope")

    condition_rule = if type == "form_data"
      scope.count == scope.hard_copy_generated(type).count
    else
      scope.count.count == scope.hard_copy_generated(type).count.count
    end

    if condition_rule
      update_column("#{type}_hard_copies_state", "completed")
    else
      Raven.capture_exception(
        "[#{ENV['MAILER_HOST']} | HARD COPY GENERATION] ERROR with generation of individual #{type} copies for #{year}!"
      )

      false
    end
  end

  def hard_copy_case_summary_scope
    form_answers.submitted
                .positive
                .joins(:assessor_assignments)
                .group("form_answers.id")
                .having("count(assessor_assignments) > 0")
                .where("assessor_assignments.submitted_at IS NOT NULL AND assessor_assignments.position IN (3,4)")
  end

  def hard_copy_feedback_scope
    form_answers.submitted
                .not_positive
                .joins(:feedback)
                .group("form_answers.id")
                .having("count(feedbacks) > 0")
                .where("feedbacks.submitted = '1'")
  end

  def hard_copy_form_data_scope
    form_answers.submitted
  end

  # +1 here is to match URN number of assosiated forms
  def self.mock_current_year?
    Rails.env.test?
  end

  def self.current
    Rails.cache.fetch "current_award_year", expires_in: 1.minute do
      return where(year: DateTime.now.year + 1).first_or_create if mock_current_year?
      now = DateTime.now
      deadline = AwardYear.where(year: now.year + 1)
                          .first_or_create
                          .settings.deadlines
                          .registrations_open_on
                          .try(:trigger_at)

      deadline ||= Date.new(now.year, 4, 21)
      if now >= deadline.to_datetime
        y = now.year + 1
      else
        y = now.year
      end

      where(year: y).first_or_create
    end
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def self.closed
    for_year(Date.current.year).first_or_create
  end

  def self.for_year(year)
    where(year: year)
  end

  def user_creation_range
    # Assumes that:
    # 1. User is created in the same calendar year as the submission period is open
    # 2. Submissions period can't cover 2 calendar years
    (DateTime.new(year - 1)..DateTime.new(year - 1, 12).end_of_month)
  end

  def self.award_holder_range
    "#{AwardYear.current.year - 5}-#{AwardYear.current.year - 1}"
  end

  def self.admin_switch
    output = {}
    year0 = 2016
    (year0..(current.year + 3)).each do |year|
      output[year] = "#{year - 1} - #{year}"
    end
    output
  end

  def settings
    @settings ||= Settings.where(award_year: self).first_or_create
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def self.past_years
    years = AVAILABLE_YEARS.slice_before(current.year).to_a
    years[0] if years.count > 1
  end

  class << self
    # so Buckingham Palace Reception date
    # is usually 14th July
    # so new award year would be already started
    # that's why we are pulling this date from current year (not current award year)

    def current_year_deadline(title)
      closed.settings
            .deadlines
            .where(kind: title)
            .first
    end

    def buckingham_palace_reception_deadline
      current_year_deadline("buckingham_palace_attendees_invite")
    end

    def buckingham_palace_reception_date
      buckingham_palace_reception_deadline.trigger_at
    end

    def buckingham_palace_reception_attendee_information_due_by
      current_year_deadline(
        "buckingham_palace_reception_attendee_information_due_by"
      ).trigger_at
    end

    def start_trading_since(years_number=3)
      Date.new(AwardYear.current.year - 1 - years_number, 9, 3).strftime("%d/%m/%Y")
    end
  end
end
