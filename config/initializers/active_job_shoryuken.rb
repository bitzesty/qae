# if Rails.env.staging? || Rails.env.production?
#   Rails.application.configure do
#     config.active_job.queue_adapter = :shoryuken
#     config.active_job.queue_name_prefix = Rails.env
#     config.active_job.queue_name_delimiter = "_"
#   end
# end

# TODO: remove block below once old servers (dev and demo) will be terminated
# and uncomment code above ^
if Rails.env.staging? || Rails.env.production?
  if ENV["AWS_ACCESS_KEY_ID"]
    Rails.application.configure do
      config.active_job.queue_adapter = :shoryuken
      config.active_job.queue_name_prefix = ENV["AWS_SQS_QUEUE_ADVANCED_PREFIX"].to_s + Rails.env
      config.active_job.queue_name_delimiter = "_"
    end
  else
    Rails.application.configure do
      config.active_job.queue_adapter = :inline
    end
  end
end
