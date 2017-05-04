class Eligibility::Mobility < Eligibility
  AWARD_NAME = 'Social Mobility'

  property :programme_validation,
            boolean: true,
            label: "Do you have one or more social mobility programmes?",
            accept: :true

  property :programme_operation,
            boolean: true,
            label: "Has the programme(s) been operational for at least the last two years?",
            accept: :true

  property :programme_commercial_success,
            boolean: true,
            label: "Has the programme(s) benefited your organisation?",
            hint: "For example, it has improved your reputation, employee relations, diversity, collaboration or led to savings or growth in the business.",
            accept: :true
end
