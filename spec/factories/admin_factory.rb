FactoryGirl.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  factory :admin do
    first_name "John"
    last_name "Doe"
    password { "strongpass" }
    email
    confirmed_at { Time.zone.now }
  end
end
