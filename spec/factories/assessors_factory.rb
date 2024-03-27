FactoryBot.define do
  factory :assessor do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    telephone_number { generate(:phone) }
    confirmed_at { Time.zone.now }

    trait :lead_for_all do
      trade_role { "lead" }
      innovation_role { "lead" }
      development_role { "lead" }
      promotion_role { "lead" }
      mobility_role { "lead" }
    end

    trait :lead_for_trade do
      trade_role { "lead" }
    end

    trait :regular_for_trade do
      trade_role { "regular" }
    end

    trait :regular_for_development do
      development_role { "regular" }
    end

    trait :regular_for_innovation do
      innovation_role { "regular" }
    end

    trait :not_avail_for_trade do
      trade_role { nil }
    end

    trait :lead_for_innovation do
      innovation_role { "lead" }
    end

    trait :lead_for_mobility do
      mobility_role { "lead" }
    end

    trait :lead_for_development_mobility do
      development_role { "lead" }
      mobility_role { "lead" }
    end

    trait :regular_for_all do
      trade_role { "regular" }
      innovation_role { "regular" }
      development_role { "regular" }
      promotion_role { "regular" }
      mobility_role { "regular" }
    end
  end
end
