FactoryGirl.define do
  factory :account do
    association :owner, factory: :user
  end
end
