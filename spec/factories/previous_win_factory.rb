FactoryGirl.define do
  factory :previous_win do
    association(:form_answer, factory: [:form_answer, :trade])
    year 2015
    category PreviousWin::CATEGORIES.values.first
  end
end
