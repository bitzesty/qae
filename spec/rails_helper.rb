# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require "shoulda/matchers"
require 'webmock/rspec'
require "simplecov"
require "codeclimate-test-reporter"

WebMock.disable_net_connect!(allow: Capybara.server_host, allow_localhost: true)

SimpleCov.add_filter "vendor"

class LineFilter < SimpleCov::Filter
  def matches?(source_file)
    source_file.lines.count < filter_argument
  end
end

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter "/lib/tasks/"
  add_filter "/app/forms/award_years/"
  add_filter "/app/pdf_generators/"
  add_filter "/app/tasks/"
  add_filter do |source_file|
    source_file.filename =~ /app\/controllers/ && source_file.lines.count < 8
  end
end

ActiveRecord::Migration.check_pending!
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

Qae::Application.load_tasks

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include UserStepDefinitions, type: :feature
  config.include ExpectationHelper, type: :feature
  config.include DeadlineHelper, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.raise_error_for_unimplemented_steps = true

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  # #build is no longer building an association if this is set to true
  # fixes some specs that use #build instead of #create
  FactoryBot.use_parent_strategy = false
  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  RSpec.configure do |config|
    config.include(Shoulda::Matchers::ActiveModel, type: :model)
    config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  end
end

def stub_sendgrid_bounced_emails_check_request(email)
  stub_request(:get, "https://sendgrid.com/api/bounces.get.jsonapi_key=test_smtp_password&api_user=test_smtp_username&email=#{email}").
    to_return(status: 200, body: "", headers: {})
end
