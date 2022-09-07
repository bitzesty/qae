FactoryBot.define do
  factory :shortlisted_documents_wrapper do
    trait :submitted do
      submitted_at { Time.zone.now }
    end
  end
end
