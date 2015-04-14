FactoryGirl.define do
  factory :form_answer do
    award_type "trade"
    association :user, factory: :user
    award_year_id { AwardYear.current.id }

    trait :submitted do
      # TOREFACTOR: should be state = submitted and submitted = true
      submitted true
    end

    trait :trade do
      award_type "trade"
      document { JSON.parse(File.read(Rails.root.join("spec/fixtures/form_answer_trade.json"))) }
    end

    trait :innovation do
      award_type "innovation"
      document { JSON.parse(File.read(Rails.root.join("spec/fixtures/form_answer_innovation.json"))) }
    end

    trait :development do
      award_type "development"
      document { JSON.parse(File.read(Rails.root.join("spec/fixtures/form_answer_development.json"))) }
    end

    trait :promotion do
      award_type "promotion"
      document { JSON.parse(File.read(Rails.root.join("spec/fixtures/form_answer_promotion.json"))) }
    end

    trait :with_audit_certificate do
      document { JSON.parse(File.read(Rails.root.join("spec/fixtures/form_answer_development.json"))) }
      audit_certificate
      award_type "development"
      state "submitted"
      submitted true
      after(:create) do |rec|
        scan = rec.audit_certificate.build_scan(status: "clean")
        scan.save(validate: false)
      end
    end
  end
end
