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
            label: "Has the programme(s) had a positive impact on your commercial success?",
            hint: "Commercial success means financial success in terms of savings or growth and might also include non-financial factors, e.g. reputation, employee relations.",
            accept: :true
end
