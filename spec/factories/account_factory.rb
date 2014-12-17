FactoryGirl.define do
  factory :account do
    association :user, factory: :user
  end
end
