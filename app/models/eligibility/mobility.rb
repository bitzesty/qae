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

  property :number_of_eligible_initiatives,
            positive_integer: true,
            label: "How many initiatives do you have that meets the criteria for the award?",
            accept: :not_nil,
            if: proc { application_category.present? && application_category == "initiative" }
end
