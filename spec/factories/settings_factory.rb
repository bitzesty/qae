FactoryGirl.define do
  factory :settings do
    year { Date.current.year }
  end

  trait :submission_deadlines do
    after(:create) do |settings|
      start = settings.deadlines.where(kind: "submission_start").first
      start.update_column(:trigger_at, Time.zone.now - 20.days)
      finish = settings.deadlines.where(kind: "submission_end").first
      finish.update_column(:trigger_at, Time.zone.now + 20.days)

      settings.reload
    end
  end
end
