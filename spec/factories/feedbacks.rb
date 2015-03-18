FactoryGirl.define do
  factory :feedback do
    association :form_answer
    submitted false
    approved false
  end
end
