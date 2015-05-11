# if Rails.env.staging? || Rails.env.production?
#   Rails.application.configure do
#     config.action_mailer.delivery_method = :smtp
#     config.action_mailer.smtp_settings = {
#       address: "email-smtp.eu-west-1.amazonaws.com",
#       port: 587,
#       domain: ENV["AWS_SES_DOMAIN_NAME"],
#       authentication: :login,
#       user_name: ENV["AWS_SES_USERNAME"],
#       password: ENV["AWS_SES_PASSWORD"],
#       enable_starttls_auto: true
#     }
#   end
# end

# TODO: remove block below once old servers (dev and demo) will be terminated
# and uncomment code above ^
if Rails.env.staging? || Rails.env.production?
  if ENV["AWS_SES_DOMAIN_NAME"]
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
  else
    Rails.application.configure do
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = {
        port:           587,
        address:        'smtp.mailgun.org',
        user_name:      ENV["mailgun_username"],
        password:       ENV["mailgun_password"],
        domain:         ENV["mailgun_domain"],
        authentication: :plain
      }
    end
  end
end
