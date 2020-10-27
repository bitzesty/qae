require 'raven'

if defined?(Raven) && ENV["VCAP_APPLICATION"].present?
  tags = JSON.parse(ENV["VCAP_APPLICATION"])
             .except('application_uris', 'host', 'application_name', 'space_id', 'port', 'uris', 'application_version')
             .merge({ server_name: ENV["GOVUK_APP_DOMAIN"] })
  Raven.configure do |config|
    config.tags = tags
    config.silence_ready = true
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.environments = [ 'production' ]
  end
end
