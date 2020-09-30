FactoryBot.define do
  factory :press_summary do
    association(:form_answer)
    body "MyText"
    comment "MyText"
    approved false
  end
end
