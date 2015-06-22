if %w{bzstaging staging production}.include?(Rails.env)
  Rails.application.configure do
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: "email-smtp.eu-west-1.amazonaws.com",
      port: 587,
      domain: ENV["AWS_SES_DOMAIN_NAME"],
      authentication: :login,
      user_name: ENV["AWS_SES_USERNAME"],
      password: ENV["AWS_SES_PASSWORD"],
      enable_starttls_auto: true
    }
  end
end
