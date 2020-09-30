FactoryBot.define do
  factory :form_answer_progress do
    form_answer_id 1
  end

  trait :second_60 do
    sections("section2" => "60")
  end
end
