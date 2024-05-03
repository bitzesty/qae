# Be sure to restart your server when you modify this file.

# We are setting up session_store settings for staging and production
# in related environment config files:
# config/environments/*.rb
if Rails.env.development? || Rails.env.test?
  Rails.application.config.session_store :cookie_store, key: "_qae_session_#{Rails.env}"
else
  Rails.application.config.session_store :cookie_store, key: "_qae_session_#{Rails.env}",
                                                        domain: ENV.fetch("COOKIE_DOMAIN", nil),
                                                        secure: true,
                                                        httponly: true
end
