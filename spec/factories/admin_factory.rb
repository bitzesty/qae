FactoryBot.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  sequence :phone do |n|
    "0207777777#{n}"
  end

  factory :admin do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    confirmed_at { Time.zone.now }
  end
end
