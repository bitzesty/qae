class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :can_provide_financial_figures,
            boolean: true,
            label: "Will you be able to provide financial figures for your three most recent financial years, covering 36 months?",
            accept: :true,
            hint: %(
              <p class='govuk-hint'>
                For the purpose of this application, your most recent financial year is your last financial year ending before the #{Settings.current.deadlines.where(kind: "submission_end").first.decorate.formatted_trigger_date('with_year')} - the application submission deadline.
              </p>
              <p class='govuk-hint'>
                If you haven't reached your most recent year-end, you can provide estimated figures in the interim.
              </p>
            )
  property :full_time_employees,
            boolean: true,
            label: "Did your organisation have at least two full-time UK employees or full-time equivalent employees (FTEs) in your three most recent financial years?",
            accept: :true,
            hint: %(
              <p class='govuk-hint'>
               You can calculate the number of full-time employees at the year-end or the average for each 12-month period. Part-time employees should be expressed in full-time equivalents (FTEs).
              </p>
            )

  property :promoting_opportunity_involvement,
            values: [
              "A. We have an initiative that supports social mobility as a discretionary activity (social mobility is not our core activity).",
              "B. We are a subsidiary with the principal activity of promoting social mobility. However, social mobility is not our parent organisation's core activity.",
              "C. We are an organisation whose core activity is to improve social mobility (this may include providing education or training), and we: i) are making a joint application with one or more businesses, and all the partners will submit separate applications, or ii) have a social mobility initiative for our own workforce.",
              "D. We are an organisation whose core activity is to improve social mobility (this may include providing education or training), and we are applying for this award on the basis of our core activity."
            ],
            label: "Your social mobility in relation to your whole organisation.",
            accept: "promoting_opportunity_involvement"

  property :promoting_social_mobility,
            boolean: true,
            label: "Have you been promoting opportunity (through social mobility) to help disadvantaged groups?",
            accept: :true,
            hint_partial: "form_award_eligibilities/questions/hints/promoting_social_mobility"

  property :participants_based_in_uk,
           boolean: true,
           label: "Are your target group members, the participants, based in the UK and were over 16 years old at the start of the engagement?",
           accept: :true

  property :social_mobility_activities,
            boolean: true,
            label: "Have your promoting opportunity (through social mobility) efforts been through one of the qualifying activities?",
            accept: :true,
            hint_partial: "form_award_eligibilities/questions/hints/social_mobility_activities"

  property :active_for_atleast_two_years,
            boolean: true,
            label: "Have you had these activities for at least two years (a minimum of 24 months)?",
            accept: :true

  property :evidence_of_impact,
            boolean: true,
            label: "Are you able to provide evidence of the impact of your promoting opportunity (through social mobility) activities, including the diversity data?",
            accept: :true,
            hint: %(
              <div class='govuk-hint'>
                <p>
                  Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.
                </p>
                <p>
                  The evidence could include but is not limited to internal records, third-party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.
                </p>
                <p>
                  Please note that you will need to provide the diversity data about the people your initiative is supporting. If you are unable to provide this data, we will be unable to assess your application effectively, and you will be ineligible. Some companies have felt they cannot provide the data due to GDPR and concerns over privacy. However, diversity data can usually be provided anonymously and with consent. If in doubt, please ring The King's Awards for Enterprise helpline to discuss this further, and we will advise.
                </p>
              </div>
            )
end
