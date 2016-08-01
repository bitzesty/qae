class AwardYear < ActiveRecord::Base
  validates :year, presence: true

  has_many :form_answers
  has_many :assessor_assignments
  has_many :feedbacks
  has_one :settings, inverse_of: :award_year, autosave: true

  has_many :aggregated_case_summary_hard_copies, -> { where(type: "case_summary") },
                                                 class_name: "AggregatedAwardYearPdf",
                                                 dependent: :destroy

  has_many :aggregated_feedback_hard_copies, -> { where(type: "feedback") },
                                                 class_name: "AggregatedAwardYearPdf",
                                                 dependent: :destroy

  after_create :create_settings

  AVAILABLE_YEARS = [2016, 2017, 2018, 2019, 2020]

  scope :past, -> {
    where(year: past_years)
  }

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

  AggregatedAwardYearPdf::TYPES_OF_GENERATING_HARD_COPIES.each do |type|
    [ "started", "completed" ].each do |action|
      define_method("#{type}_hard_copies_#{action}?") do
        send("#{type}_hard_copies_state").to_s == action
      end
    end
  end

  def form_data_generation_can_be_started?
    settings.after_current_submission_deadline? &&
    !form_data_hard_copies_completed? &&
    !form_data_hard_copies_started?
  end

  def case_summary_generation_can_be_started?
    settings.winners_stage? &&
    !case_summary_hard_copies_completed? &&
    !case_summary_hard_copies_started?
  end

  def feedback_generation_can_be_started?
    settings.unsuccessful_stage? &&
    !feedback_hard_copies_completed? &&
    !feedback_hard_copies_started?
  end

  def check_hard_copy_pdf_generation_status!(mode)
    if form_answers.submitted.count == form_answers.hard_copy_generated(mode).count
      update_column("#{mode}_hard_copies_state", "completed")
    else
      Raven.capture_exception(
        "[HARD COPY GENERATION] ERROR with generation of #{mode} copies for #{year}!"
      )
    end
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
