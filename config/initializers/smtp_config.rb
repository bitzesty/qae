unless Rails.env.development? || Rails.env.test?
  Rails.application.configure do
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV["SMTP_ADDRESS"],
      port: ENV["SMTP_PORT"],
      domain: ENV["SMTP_DOMAIN"],
      authentication: ENV["SMTP_AUTHENTICATION"],
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      enable_starttls_auto: true
    }
  end
end
