class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :programme_validation,
            boolean: true,
            label: "Do you have one or more qualifying social mobility programme?",
            accept: :true,
            hint: %(
              <p class='question-context'>
                Qualifying programme should be in one of the following areas to help socially disadvantaged individuals or groups:
              </p>
              <ul class='question-context'>
                <li>Work experience, careers advice or mentoring for young people;</li>
                <li>Offering non-graduate routes such as traineeships or changing recruitment practices;</li>
                <li>Giving equal support and progression opportunities to all employees.</li>
              </ul>
              <p class='question-context'>
                Please note, a programme could be an initiative, activity, course, system, business model approach or strategy, service or application, practice, policy or product.
              </p>
            )

  property :programme_operation,
            boolean: true,
            label: "Has the programme(s) been operational for at least the last two years?",
            accept: :true

  property :active_for_atleast_two_years,
            boolean: true,
            label: "Have you had these activities for at least two years?",
            accept: :true

  property :application_category,
            label: "Is your application going to be for:",
            values: [
              ["initiative", "<strong>An initiative</strong> which promotes opportunity through social mobility. The initiative should be structured and designed to target and support people from disadvantaged backgrounds."],
              ["organisation", "<strong>A whole organisation</strong> whose core aim is to promote opportunity through social mobility. The organisation exists purely to support people from disadvantaged backgrounds."]
            ],
            context_for_options: {
              "initiative": "<a href='#' class='js-form-expandable-content-link' data-ref='js-application-category-initiative'>Read more about this option.</a>
                            <div class='js-application-category-initiative'>
                              <p>Please note, an initiative could be a programme, activity, course, system, business model approach or strategy, service or application, practice, policy or product. It can include activities to promote opportunity directly in your organisation or through local or national outreach initiatives.</p>
                              <p>For example, it may be an apprenticeship scheme by an SME or charity that has a target of some of these apprentices to be from a disadvantaged socio-economic background, with the aim of most of those apprentices going into employment after the apprenticeship ends. Or it may be a recruitment initiative by a large corporation that aims to have a certain number of recruits to come from disadvantaged backgrounds.</p>
                              <p>If your application is for an initiative, promoting opportunity through social mobility <strong>does not</strong> have to be your organisation's core aim.</p>
                            </div>",
              "organisation": "<a href='#' class='js-form-expandable-content-link' data-ref='js-application-category-organisation'>Read more about this option.</a>
                               <div class='js-application-category-organisation'>
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
