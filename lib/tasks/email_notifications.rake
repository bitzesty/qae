namespace :email_notifications do
  desc "Migrates all unsuccessful emails to unsuccessful"
  task :migrate_unsuccessful, [:id] => [:environment] do |t, args|
    EmailNotification.where(kind: "all_unsuccessful_feedback").update_all(kind: "unsuccessful_notification")
  end
end
