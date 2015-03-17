# TODO: remove else condition - once old servers (dev and demo) will be terminated
if (Rails.env.staging? || Rails.env.production?) && ENV["AWS_ACCESS_KEY_ID"].present?
  Rails.application.configure do
    config.active_job.queue_adapter = :shoryuken
    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = "_"
  end
else
  Rails.application.configure do
    config.active_job.queue_adapter = :inline
  end
end
