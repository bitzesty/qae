FactoryBot.define do
  factory :support_letter do
    association :user
    association :form_answer
    association :supporter
    first_name "Test"
    last_name "Test"
    relationship_to_nominee "Test"
    body "MyText"
  end
end
