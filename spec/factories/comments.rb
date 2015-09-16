FactoryGirl.define do
  factory :comment do
    body "comment body"
    authorable { create(:admin) }

    flagged false

    trait :admin do
      section 0
    end

    trait :assessor do
      section 1
    end

    trait :flagged do
      flagged true
    end
  end
end
