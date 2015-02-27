FactoryGirl.define do
  factory :assessor do
    role "regular"
    first_name "John"
    last_name "Doe"
    password { "strongpass" }
    email
    confirmed_at { Time.zone.now }

    trait :lead do
      role "lead"
    end
  end
end
