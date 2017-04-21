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
            label: "Has the programme(s) benefited your organisation financially or otherwise?",
            hint: "For example, it has improved your reputation or led to savings in the business.",
            accept: :true
end
