default_schedule = {
  "email_notification_service" => {
    "cron" => "0 * * * *",
    "class" => "Scheduled::EmailNotificationServiceWorker"
  },
  "trigger_audit_deadlines" => {
    "cron" => "0 * * * *",
    "class" => "Scheduled::AuditDeadlineWorker"
  }
}

production_schedule = {
  "performance_platform_service" => {
    "cron" => "0 0 * * 0",
    "class" => "Scheduled::PerformancePlatformServiceWorker"
  }
}

Sidekiq.configure_server do |config|
  config.on(:startup) do
    if ENV["SCHEDULE_PRODUCTION_JOBS"].present?
      Sidekiq::Cron::Job.load_from_hash(default_schedule.merge(production_schedule))
    else
      Sidekiq::Cron::Job.load_from_hash(default_schedule)
    end
  end
end
