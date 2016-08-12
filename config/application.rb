require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qae
  class Application < Rails::Application
    initializer :regenerate_require_cache, before: :load_environment_config do
      Bootscale.regenerate
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.middleware.use Rack::SslEnforcer, except: "/healthcheck", except_environments: ["development", "test"]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.autoload_paths += %W( #{config.root}/app/forms/ #{config.root}/app/search/ )

    config.generators do |g|
      g.test_framework :rspec
    end

    config.cache_store = :memory_store
    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :sidekiq
  end
end
