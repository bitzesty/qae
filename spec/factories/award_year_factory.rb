FactoryBot.define do
  factory :award_year do
    year { Date.current.year }
  end
end
