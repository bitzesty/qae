FactoryBot.define do
  factory :judge do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    confirmed_at { Time.zone.now }
  end

  trait :trade do
    trade_role { "judge" }
  end

  trait :innovation do
    innovation_role { "judge" }
  end
end
