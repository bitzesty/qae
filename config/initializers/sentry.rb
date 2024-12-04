# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger]
  config.dsn = ENV["SENTRY_DSN"]
  config.environment = ENV["SENTRY_ENV"]
  config.enable_tracing = true
  config.release = ENV["APP_REVISION"]
  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, hint|
    filter.filter(event.to_hash)
  end
  config.sidekiq.report_after_job_retries = true
end
