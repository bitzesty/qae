FactoryBot.define do
  factory :form_answer_attachment do
    association :form_answer, factory: :form_answer
    file do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/cat.jpg"),
      )
    end

    trait :restricted_to_admin do
      restricted_to_admin { true }
    end
  end
end
