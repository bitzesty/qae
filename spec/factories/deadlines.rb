FactoryBot.define do
  factory :deadline do
    kind { "innovation_submission_start" }
    trigger_at { "2015-03-09 14:41:02" }
    settings { Settings.current }
  end
end
