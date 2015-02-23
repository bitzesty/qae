FactoryGirl.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  factory :admin do
    password { 'strongpass' }
    role 'admin'
    email
    confirmed_at { Time.zone.now }

    trait :lead_assessor do
      role 'lead_assessor'
    end

    trait :assessor do
      role 'assessor'
    end
  end
end
