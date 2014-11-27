FactoryGirl.define do
  factory :form_answer do
    association :user, factory: :user
  end
end