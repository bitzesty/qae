class Eligibility::Development < Eligibility
  AWARD_NAME = 'Sustainable Development'

  property :can_provide_financial_figures,
            boolean: true,
            label: "Will you be able to provide financial figures for at least your two most recent financial years, covering a minimum of 24 months?",
            accept: :true,
            hint: proc {
              "<p class='govuk-hint'>For the purpose of this application, your most recent financial year-end is your last financial year-end before the #{Settings.current_submission_deadline.decorate.formatted_trigger_time} - the application submission deadline. If you haven't reached your most recent year-end, you can provide estimated figures in the interim.</p>
              <p class='govuk-hint'>If your financial year end has changed within your last two financial years, and one of the periods is shorter than 12 months, you will have to provide figures for at least one additional year.</p>"
            }

  property :has_two_employees,
            boolean: true,
            label: "Did your organisation have at least two full-time UK employees, in your two most recent financial years?",
            accept: :true,
            hint: "You can calculate the number of full-time employees at the year-end, or the average for each 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs)."


  property :sustainable_development,
            values: %w[yes no skip],
            acts_like_boolean: true,
            label: "Have you had a substantial sustainable development action or intervention for at least the last two years?",
            accept: :true
end
