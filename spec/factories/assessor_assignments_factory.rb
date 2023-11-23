FactoryBot.define do
  factory :assessor_assignment do
    association :form_answer

    trait :trade do
      form_answer { create(:form_answer, :trade) }
    end

    trait :development do
      form_answer { create(:form_answer, :development) }
    end

    trait :submitted do
      submitted_at { DateTime.now - 1.minute }
    end

    trait :locked do
      locked_at { DateTime.now - 1.minute }
    end
  end

  factory :assessor_assignment_moderated, class: AssessorAssignment do
    association :form_answer
    position { "moderated" }
  end
end
