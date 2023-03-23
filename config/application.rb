require_relative 'boot'

require 'rails/all'
require "govuk/components"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qae
  class Application < Rails::Application
    #initializer :regenerate_require_cache, before: :load_environment_config do
    #  Bootscale.regenerate
    #end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.middleware.use Rack::SslEnforcer, except: "/healthcheck", except_environments: ["development", "test"]

    config.action_mailer.delivery_job = "ActionMailer::MailDeliveryJob"

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    #NOTE: This works like Rails 4. For Rails 5, we can use
    # `config.eager_load_paths << Rails.root.join('lib')` but still it is not recommended for Threadsafty.
    # Need to take look in to it.
    config.enable_dependency_loading = true
    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.test_framework :rspec
    end

    config.cache_store = :memory_store
    config.active_record.schema_format = :sql
    config.active_job.queue_adapter = :sidekiq
    config.action_view.automatically_disable_submit_tag = false
  end
end
