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
            label: "Are you able to provide financial figures for the last three years for your organisation?",
            accept: :true,
            hint: proc { "<p class='govuk-hint'>You will have to submit data for the last three financial years. Your latest financial year has to be the one that falls before the #{Settings.current_submission_deadline.decorate.formatted_trigger_time} (the submission deadline). If you haven't reached or finalised your latest year-end yet, you will be able to provide estimated figures.</p>" }

  property :promoting_social_mobility,
            boolean: true,
            label: "Have you been promoting opportunity through social mobility helping disadvantaged groups as listed below?",
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
            label: "Are you able to provide evidence of the impact of your promoting opportunity through social mobility activities?",
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
            accept: :not_nil
end
