FactoryGirl.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  factory :admin do
    password { 'strongpass' }
    email
    confirmed_at { Time.zone.now }
  end
end
