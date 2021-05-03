class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :can_provide_financial_figures,
            boolean: true,
            label: "Are you able to provide financial figures for the last three years for your organisation?",
            accept: :true,
            hint: proc { "<p class='question-context'>You will have to submit data for the last three financial years. Your latest financial year has to be the one that falls before the #{Settings.current_submission_deadline.decorate.formatted_trigger_time} (the submission deadline). If you haven't reached or finalised your latest year-end yet, you will be able to provide estimated figures.</p>" }

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
              <div class='question-context'>
                <p>Applicants need to provide quantitative evidence (for example, numbers, figures) and qualitative evidence (for example, stories, quotes) to support the claims made.</p>
                <p>The evidence could be but is not limited to - internal records, third party data, survey responses, interviews, ad-hoc feedback. Please note, while quotes and anecdotal feedback will strengthen your application, they are not sufficient on their own.</p>
              </div>
            )

  property :application_category,
            label: "Is your application going to be for:",
            values: [
              ["initiative", "<strong>An initiative</strong> which promotes opportunity through social mobility. The initiative should be structured and designed to target and support people from disadvantaged backgrounds."],
              ["organisation", "<strong>A whole organisation</strong> whose core aim is to promote opportunity through social mobility. The organisation exists purely to support people from disadvantaged backgrounds."]
            ],
            context_for_options: {
              "initiative": "<div class='question-context'>
                               <p>Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.</p>
                               <p>For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain number of recruits to come from disadvantaged backgrounds.</p>
                               <p>If your application is for an initiative, promoting opportunity through social mobility <strong>does not</strong> have to be your organisation's core aim.</p>
                             </div>",

              "organisation": "<div class='question-context'>
                                 <p>For example, it may be a charity with a mission to help young people from less-advantaged backgrounds to secure jobs. Or it may be a company that is focused solely on providing skills training for people with disabilities to improve their employment prospects.</p>
                               </div>"
            },
            accept: :not_nil

  property :number_of_eligible_initiatives,
            positive_integer: true,
            label: "How many initiatives do you have that meets the criteria for the award?",
            accept: :not_nil,
            if: proc { application_category.present? && application_category == "initiative" }
end
