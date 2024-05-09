class Eligibility::Development < Eligibility
  AWARD_NAME = "Sustainable Development"

  property :able_to_provide_actual_figures,
    boolean: true,
    label: "Will you be able to provide financial figures for your three most recent financial years, covering 36 months?",
    accept: :true,
    hint: %(
              <p class='govuk-hint'>
                For the purpose of this application, your most recent financial year is your last financial year ending before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date("with_year")} - the application submission deadline.
              </p>
              <p class='govuk-hint'>
                If you haven't reached your most recent year-end, you can provide estimated figures in the interim.
              </p>
            )

  property :has_management_and_two_employees,
    label: "Did your organisation have at least two full-time UK employees or full-time equivalent employees (FTEs) in your two most recent financial years?",
    accept: :true,
    boolean: true,
    hint: %(
              <p class='govuk-hint'>You can calculate the number of full-time employees at the year-end, or the average for each 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).</p>
              <p class='govuk-hint'>If your organisation is based in the Channel Islands or Isle of Man, you should count only the employees who are located there (do not count employees who are in the UK).</p>
            )

  property :sustainable_development,
    boolean: true,
    label: "Can you demonstrate outstanding achievement in sustainable development for at least the last two years?",
    accept: :true,
    hint: %(
              <p class='govuk-hint'>
                You may find it helpful to familiarise yourself with the <a class='govuk-link' target='_blank' href='https://www.un.org/sustainabledevelopment/sustainable-development-goals/.'>United Nations 17 Sustainable Development Goals (UN SDGs).</a>
              </p>
              <p class='govuk-hint'>
                You will not need to show impact in each of these areas, only the ones that are most applicable to your sustainable development interventions.
              </p>
            )

  property :adheres_to_sustainable_principles,
    boolean: true,
    label: "Can you demonstrate that the organisation as a whole adheres to sustainable practices?",
    accept: :true,
    hint: %(
              <p class='govuk-hint'>
                Please note, we are assessing the whole organisation, not just particular interventions. At a minimum, we expect all winning organisations to have good practices around climate change.
              </p>
            )
end
