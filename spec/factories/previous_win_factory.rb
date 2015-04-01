FactoryGirl.define do
  factory :previous_win do
    form_answer
    year 2015
    category PreviousWin::CATEGORIES.values.first
  end
end
