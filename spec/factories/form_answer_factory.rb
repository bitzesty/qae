FactoryBot.define do
  factory :form_answer do
    award_type { "trade" }
    association :user, factory: %i[user agreed_to_be_contacted]
    award_year_id { AwardYear.current.id }

    trait :submitted do
      submitted_at { Time.current }
      state { "submitted" }
    end

    trait :awarded do
      submitted_at { Time.current }
      state { "awarded" }
    end

    trait :recommended do
      submitted_at { Time.current }
      state { "recommended" }
    end

    trait :withdrawn do
      state { "withdrawn" }
    end

    trait :not_recommended do
      submitted_at { Time.current }
      state { "not_recommended" }
    end

    trait :not_awarded do
      submitted_at { Time.current }
      state { "not_awarded" }
    end

    trait :reserved do
      submitted_at { Time.current }
      state { "reserved" }
    end

    trait :trade do
      award_type { "trade" }
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_trade.json")),
          ),
        )
      end
    end

    trait :innovation do
      award_type { "innovation" }
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_innovation.json")),
          ),
        )
      end
    end

    trait :development do
      award_type { "development" }
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_development.json")),
          ),
        )
      end
    end

    trait :mobility do
      award_type { "mobility" }
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_mobility.json")),
          ),
        )
      end
    end

    trait :promotion do
      award_type { "promotion" }
      award_year_id { AwardYear.where(year: 2018).first_or_create.id }
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_promotion.json")),
          ),
        )
      end
    end

    trait :with_audit_certificate do
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_trade.json")),
          ),
        )
      end
      audit_certificate
      award_type { "trade" }
      state { "submitted" }
      submitted_at { Time.current }
    end
  end
end
