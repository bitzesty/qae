require Rails.root.join("lib/formatters/asim_formatter")
require Rails.root.join("lib/credentials_resolver")

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = true # ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.public_file_server.headers = {
    "Cache-Control" => "public, s-maxage=31536000, max-age=15552000",
    "Expires" => 1.year.from_now.to_formatted_s(:rfc822),
  }

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Uglifier.new(harmony: true)

  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  config.action_controller.asset_host = ENV["ASSET_HOST"]

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = ENV["LOG_LEVEL"].presence || :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  config.cache_store = :redis_cache_store, { url: CredentialsResolver.redis_uri }

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: ENV["MAILER_HOST"] }
  config.action_mailer.asset_host = "https://#{ENV["ASSET_HOST"]}"
  config.action_mailer.delivery_method = :notify
  config.action_mailer.notify_settings = {
    api_key: ENV["GOV_UK_NOTIFY_API_KEY"],
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  config.log_tags = JsonTaggedLogger::LogTagsConfig.generate(
    :request_id,
    :remote_ip,
    JsonTaggedLogger::TagFromSession.get(:user_id),
    :user_agent,
  )
  logger = ActiveSupport::Logger.new($stdout)
  config.logger = JsonTaggedLogger::Logger.new(logger)

  config.lograge.enabled = true
  config.lograge.ignore_actions = ["HealthcheckController#index"]
  config.lograge.formatter = Formatters::AsimFormatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
