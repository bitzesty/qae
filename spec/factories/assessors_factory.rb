FactoryGirl.define do
  factory :assessor do
    first_name "John"
    last_name "Doe"
    password { "strongpass" }
    email
    confirmed_at { Time.zone.now }

    trait :lead_for_all do
      trade_role "lead"
      innovation_role "lead"
      development_role "lead"
      promotion_role "lead"
    end

    trait :lead_for_trade do
      trade_role "lead"
    end

    trait :regular_for_trade do
      trade_role "regular"
    end

    trait :not_avail_for_trade do
      trade_role nil
    end

    trait :regular_for_all do
      trade_role "regular"
      innovation_role "regular"
      development_role "regular"
      promotion_role "regular"
    end
  end
end
