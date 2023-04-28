FactoryBot.define do
  factory :settings do
    skip_create

    initialize_with do
      begin
        Settings.where(attributes).first_or_create
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end
  end

  trait :submission_deadlines do
    after(:create) do |settings|
      %w(innovation trade mobility development).each do |award|
        settings.deadlines.where(kind: "#{award}_submission_start").first.update_column(:trigger_at, Time.zone.now - 20.days)
      end

      finish = settings.deadlines.where(kind: "submission_end").first
      finish.update_column(:trigger_at, Time.zone.now + 20.days)

      settings.reload
    end
  end

  trait :expired_submission_deadlines do
    after(:create) do |settings|
      start = settings.deadlines.where(kind: "submission_start").first
      start.update_column(:trigger_at, Time.zone.now - 25.days)
      finish = settings.deadlines.where(kind: "submission_end").first
      finish.update_column(:trigger_at, Time.zone.now - 20.days)

      settings.reload
    end
  end

  trait :current_award_year_switch_date do
    after(:create) do |settings|
      start = settings.deadlines.where(kind: "award_year_switch").first
      start.update_column(:trigger_at, Time.zone.now - 25.days)
      settings.reload
    end
  end

  trait :expired_audit_submission_deadline do
    after(:create) do |settings|
      start = settings.deadlines.where(kind: "audit_certificates").first
      start.update_column(:trigger_at, Time.zone.now - 25.days)

      settings.reload
    end
  end
end
