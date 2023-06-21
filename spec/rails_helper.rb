# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require "simplecov"
require "codeclimate-test-reporter"

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

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require "capybara/rspec"
require "shoulda/matchers"
require "webmock/rspec"
require 'selenium-webdriver'

Dotenv.overload('.env.test')

WebMock.disable_net_connect!(allow: "codeclimate.com", allow_localhost: true, net_http_connect_on_start: true)

# Require all support files.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.server = :puma

Capybara.register_driver(:chrome_headless) do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1400,1400')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :chrome_headless
Capybara.default_max_wait_time = 5

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
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
Qae::Application.load_tasks

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include UserStepDefinitions, type: :feature
  config.include ExpectationHelper, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.raise_error_for_unimplemented_steps = true

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  # #build is no longer building an association if this is set to true
  # fixes some specs that use #build instead of #create
  FactoryBot.use_parent_strategy = false

  config.before :each do
    # SENDGRID RELATED STUBS - BEGIN
    stub_request(:get, "https://sendgrid.com/api/spamreports.get.json?api_key=test_smtp_password&api_user=test_smtp_username&email=test@example.com").
      to_return(status: 200, body: "", headers: {})

    stub_sendgrid_bounced_emails_check_request("test@irrelevant.com")
    stub_sendgrid_bounced_emails_check_request("test@example.com")
    # SENDGRID RELATED STUBS - END

    AwardYear.current
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
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
