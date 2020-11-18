if defined?(Sentry) && ENV["VCAP_APPLICATION"].present?
  tags = JSON.parse(ENV["VCAP_APPLICATION"])
             .except('application_uris', 'host', 'application_name', 'space_id', 'port', 'uris', 'application_version')
  Sentry.configure_scope do |scope|
    config.set_tags = tags
  end
end
