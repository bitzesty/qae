default_schedule = {
  "email_notification_service" => {
    "cron" => "*/30 * * * *",
    "class" => "Scheduled::EmailNotificationServiceWorker",
  },
  "trigger_audit_deadlines" => {
    "cron" => "0 * * * *",
    "class" => "Scheduled::AuditDeadlineWorker",
  },
  "trigger_submission_deadlines" => {
    "cron" => "0 * * * *",
    "class" => "Scheduled::SubmissionDeadlineWorker",
  },
  "form_data_pdf_hard_copy_generation_service" => {
    "cron" => "30 0 * * *",
    "class" => "HardCopyPdfGenerators::Collection::FormDataWorker",
  },
  "case_summary_pdf_hard_copy_generation_service" => {
    "cron" => "30 2 * * *",
    "class" => "HardCopyPdfGenerators::Collection::CaseSummaryWorker",
  },
  "feedback_pdf_hard_copy_generation_service" => {
    "cron" => "30 4 * * *",
    "class" => "HardCopyPdfGenerators::Collection::FeedbackWorker",
  },
  "aggregated_case_summary_pdf_hard_copy_generation_service" => {
    "cron" => "10 5 * * *",
    "class" => "HardCopyPdfGenerators::Aggregated::CaseSummariesWorker",
  },
  "aggregated_feedback_pdf_hard_copy_generation_service" => {
    "cron" => "30 5 * * *",
    "class" => "HardCopyPdfGenerators::Aggregated::FeedbacksWorker",
  },
  "debounce_check_service" => {
    "cron" => "50 5 * * *",
    "class" => "Scheduled::DebounceApiScanWorker",
  },
  "rescan_service" => {
    "cron" => "30 1 * * *",
    "class" => "Scheduled::RescanServiceWorker",
  },
}

production_schedule = {
  "performance_platform_service" => {
    "cron" => "0 0 * * 0",
    "class" => "Scheduled::PerformancePlatformServiceWorker",
  },
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
