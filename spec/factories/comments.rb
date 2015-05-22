FactoryGirl.define do
  factory :comment do
    body 'Comment body'
    authorable { create(:admin) }
  end

  factory :flagged_comment, class: Comment do
    body "comment body"
    flagged true

    trait :admin do
      section 0
    end

    trait :assessor do
      section 1
    end
  end
end
