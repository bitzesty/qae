class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :promoting_opportunity_involvement,
            values: [
              "Our main activity is focused on something else, but we have activities or initiatives that are positively supporting social mobility",
              "Our organisation's core purpose is to improve social mobility"
            ],
            label: "Which of the below best describes your involvement with promoting opportunity through social mobility:",
            accept: "other_focus"

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

  property :promoting_social_mobility,
            boolean: true,
            label: "Have you been promoting opportunity (through social mobility) to help disadvantaged groups",
            accept: :true,
            hint_partial: "form_award_eligibilities/questions/hints/promoting_social_mobility"

  property :participants_based_in_uk,
           boolean: true,
           label: "Are your target group members, the participants, based in the UK and were over 16 years old at the start of the engagement?",
           accept: :true

  property :social_mobility_activities,
            boolean: true,
            label: "Have your promoting opportunity through social mobility efforts been through one of the qualifying activities as listed below?",
            accept: :true,
            hint_partial: "form_award_eligibilities/questions/hints/social_mobility_activities"

  property :active_for_atleast_two_years,
            boolean: true,
            label: "Have you had these activities for at least two years?",
            accept: :true

  property :evidence_of_impact,
            boolean: true,
            label: "Are you able to provide evidence of the impact of your promoting opportunity (through social mobility) activities?",
            accept: :true,
            hint: %(
              <div class='govuk-hint'>
                <p>Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.</p>
                <p>The evidence could be but is not limited to - internal records, third party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.</p>
              </div>
            )

  property :number_of_eligible_initiatives,
            positive_integer: true,
            label: "How many initiatives do you have that meets the criteria for the award?",
            accept: :all
end
