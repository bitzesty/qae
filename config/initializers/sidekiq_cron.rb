default_schedule = {
  "email_notification_service" => {
    "cron" => "0 * * * *",
    "class" => "Scheduled::EmailNotificationServiceWorker"
  }
}

production_schedule = {
  "performance_platform_service" => {
    "cron" => "0 0 * * 0",
    "class" => "Scheduled::PerformancePlatformServiceWorker"
  }
}
unless ENV["ONLY_ASSETS"]
  if ENV["SCHEDULE_PRODUCTION_JOBS"].present?
    Sidekiq::Cron::Job.load_from_hash(production_schedule)
  else
    Sidekiq::Cron::Job.load_from_hash(default_schedule)
  end
end
