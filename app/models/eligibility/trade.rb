class Eligibility::Trade < Eligibility
  AWARD_NAME = "International Trade"

  validates :current_holder_of_qae_for_trade,
    presence: true,
    if: proc {
      (current_step == :current_holder_of_qae_for_trade || force_validate_now.present?) &&
          current_holder_of_an_award?
    }, on: :update

  validates :qae_for_trade_award_year,
    presence: true,
    not_a_last_year_winner: true,
    if: proc {
      current_holder_of_an_award? &&
          (current_step == :qae_for_trade_award_year || force_validate_now.present?) &&
          current_holder_of_qae_for_trade?
    }, on: :update

  property :growth_over_the_last_three_years,
    label: "Have you had significant growth in overseas sales over the period of your entry (either a 3 or 6-year period)?",
    accept: :true,
    boolean: true,
    hint: %(
              <p class='govuk-hint'>
                You can choose to be assessed for outstanding growth (over three years - 36 consecutive months) or continuous growth (over six years - 72 consecutive months). Both options enable you to use the King's Awards emblem for five years.
              </p>
              <ul class='govuk-hint'>
                <li>Outstanding Short Term Growth: a steep year-on-year growth (without dips) over the three most recent financial years</li>
                <li>Outstanding Continued Growth: a substantial year-on-year growth (without dips) over the six most recent financial years</li>
              </ul>
              <p class='govuk-hint'>
                For the purpose of this application, your most recent financial year is your last financial year ending before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} - the application submission deadline.
              </p>
            )

  property :sales_above_100_000_pounds,
    boolean: true,
    label: "Have you made a minimum of £100,000 in overseas sales in each year of your entry (either 3 or 6-year period)?",
    accept: :true

  property :any_dips_over_the_last_three_years,
    label: "Have you had any dips in your overseas sales over the period of your entry (either 3 or 6-year period)?",
    accept: :false,
    boolean: true

  property :has_management_and_two_employees,
    label: "Did your organisation have at least two full-time UK employees or full-time equivalent employees (FTEs) in your two most recent financial years?",
    accept: :true,
    boolean: true,
    hint: %(
              <p class='govuk-hint'>You can calculate the number of full-time employees at the year-end, or the average for each 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>
              <p class='govuk-hint'>If your organisation is based in the Channel Islands or Isle of Man, you should count only the employees who are located there (do not count employees who are in the UK).</p>
            )

  property :current_holder_of_qae_for_trade,
    label: "Are you a current holder of a Queen's/King's Award for International Trade?",
    boolean: true,
    accept: :all,
    if: proc { current_holder_of_an_award? }

  property :qae_for_trade_award_year,
    values: (AwardYear.current.year - 5..AwardYear.current.year - 1).to_a.reverse + ["before_#{AwardYear.current.year - 5}"],
    accept: :not_nil_if_current_holder_of_qae_for_trade,
    label: "In which year did you receive the award?",
    if: proc { current_holder_of_an_award? && current_holder_of_qae_for_trade? },
    allow_nil: true

  private

  def current_holder_of_an_award?
    account_holder_of_an_award? || application_holder_of_an_award?
  end

  def account_holder_of_an_award?
    account.basic_eligibility.current_holder == "yes"
  end

  def application_holder_of_an_award?
    form_answer &&
        form_answer.form_basic_eligibility.present? &&
        form_answer.form_basic_eligibility.current_holder == "yes"
  end
end
