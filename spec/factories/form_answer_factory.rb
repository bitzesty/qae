FactoryGirl.define do
  factory :form_answer do
    award_type "trade"
    association :user, factory: :user

    trait :submitted do
      submitted true
    end

    trait :trade do
      award_type "trade"
    end

    trait :innovation do
      award_type "innovation"
    end

    trait :development do
      award_type "development"
    end

    trait :promotion do
      award_type "promotion"
    end
  end
end
