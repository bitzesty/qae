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

  property :programme_commercial_success,
            boolean: true,
            label: "Can you demonstrate that the programme(s) benefited your organisation or employees?",
            hint: "For example, can you provide evidence that it has improved your reputation, employee relations, diversity, collaboration or led to savings or growth in the business?",
            accept: :true
end
