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
    end
  end
end
