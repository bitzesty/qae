FactoryGirl.define do
  factory :supporter do
    association :form_answer, factory: :form_answer
    email "supporter@example.com"
  end
end
