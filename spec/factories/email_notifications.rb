FactoryGirl.define do
  factory :email_notification do
    kind "reminder_to_submit"
    sent false
    trigger_at "2015-03-09 17:34:48"
    settings { Settings.current }
  end
end
