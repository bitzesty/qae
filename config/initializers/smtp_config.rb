if Rails.env.production?
  Rails.application.configure do
    config.action_mailer.delivery_method = :notify
    config.action_mailer.notify_settings = {
      api_key: ENV["GOV_UK_NOTIFY_API_KEY"],
    }
  end
end
