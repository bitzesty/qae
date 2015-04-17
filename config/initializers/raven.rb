require 'raven'

Raven.configure do |config|
  config.silence_ready = true
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
