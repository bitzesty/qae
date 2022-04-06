Vigilion.configure do |config|
  config.access_key_id = ENV["VIGILION_ACCESS_KEY_ID"] || "Replace me"
  config.secret_access_key = ENV["VIGILION_SECRET_ACCESS_KEY"] || "Replace me"

  config.server_url = ENV["VIGILION_SERVER_URL"] if ENV["VIGILION_SERVER_URL"].present?
  # Integration strategy (default is :url)
  # config.integration = :local

  # By default vigilion will be bypassed in development and test environments.
  # Disable vigilion scanning entirely even in production environments:
  # config.loopback = true
  # Enable vigilion scanning even in development and test environments:
  # (Note that the callback URL probably won't be reached)
  config.loopback = ENV["DISABLE_VIRUS_SCANNER"] == "true"
  # Specify different loopback_response (default is 'clean')
  # config.loopback_response = 'infected'
  config.debug = ENV["DEBUG_VIRUS_SCANNER"] == "true"
  config.active_job = ENV["VIRUS_SCANNER_ACTIVE_JOB"] == "true"
end
