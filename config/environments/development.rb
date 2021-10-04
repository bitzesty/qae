Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  # if Rails.root.join('tmp', 'caching-dev.txt').exist?
  #   config.cache_store = :memory_store
  #   config.public_file_server.headers = {
  #     'Cache-Control' => "public, max-age=#{2.days.to_i}"
  #   }
  # else
  #   config.cache_store = :null_store
  # end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Do not compress assets.
  config.assets.compress = false

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'], port: 3000 }
  config.action_mailer.asset_host = "https://#{ENV['ASSET_HOST']}"
  config.action_mailer.delivery_method = :letter_opener
  # config.action_mailer.delivery_method = :notify
  # config.action_mailer.notify_settings = {
  #   api_key: ENV['GOV_UK_NOTIFY_API_KEY']
  # }
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # configure the devise email layout
  # config.to_prepare { Devise::Mailer.layout "mailer" }

  # Configure Rails.logger to log to both STDOUT and development.log file.
  config.log_level = :debug

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_view.annotate_rendered_view_with_filenames = true
end
