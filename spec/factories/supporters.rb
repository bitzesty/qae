FactoryGirl.define do
  factory :supporter do
    association :user
    association :form_answer
    first_name "Test"
    last_name "Test"
    relationship_to_nominee "Test"
    email "supporter@example.com"
  end
end
