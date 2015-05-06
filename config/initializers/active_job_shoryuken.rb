if Rails.env.staging? || Rails.env.production?
  Rails.application.configure do
    config.active_job.queue_adapter = :shoryuken
    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = "_"
  end
end
