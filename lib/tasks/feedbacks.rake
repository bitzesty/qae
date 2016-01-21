namespace :feedbacks do
  desc "Add locked_at to all submitted feedbacks"
  task :populate_locked_at => :environment do
    Feedback.submitted.where(locked_at: nil).update_all(locked_at: Time.zone.now)
  end
end
