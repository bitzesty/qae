FactoryBot.define do
  factory :feedback do
    association :form_answer
    submitted false
  end
end
