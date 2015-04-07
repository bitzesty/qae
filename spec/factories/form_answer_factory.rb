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

    trait :submitted do
      submitted true
    end

    trait :with_audit_certificate do
      document do
        file = "#{Rails.root}/spec/fixtures/form_answer_document_with_review_audit_certificate_criteria.json"
        JSON.parse(File.open(file).read)
      end
      audit_certificate
      award_type "development"
      state "submitted"
      submitted true
    end
  end
end
