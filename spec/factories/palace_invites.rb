FactoryBot.define do
  factory :palace_invite do
    email { "MyString" }
    association :form_answer
  end
end
