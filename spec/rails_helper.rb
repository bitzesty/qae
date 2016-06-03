ENV["RAILS_ENV"] ||= "test"
ENV["VIRUS_SCANNER_API_URL"] ||= "http://virus.scanner"
ENV["VIRUS_SCANNER_API_KEY"] ||= "random_api_key"

<<<<<<< HEAD
require 'simplecov'
require "codeclimate-test-reporter"
SimpleCov.add_filter 'vendor'
=======
require "simplecov"
require "codeclimate-test-reporter"
SimpleCov.add_filter "vendor"
>>>>>>> master
SimpleCov.formatters = []
SimpleCov.start CodeClimate::TestReporter.configuration.profile

require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rspec"
require "shoulda/matchers"
require "capybara-screenshot/rspec"
require "webmock/rspec"

WebMock.disable_net_connect!(allow: "codeclimate.com", allow_localhost: true)

# Require all support files.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

Capybara.javascript_driver = :webkit
Capybara::Screenshot.webkit_options = { width: 1024, height: 768 }

ActiveRecord::Migration.check_pending!
ActiveRecord::Migration.maintain_test_schema!
Qae::Application.load_tasks

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UserStepDefinitions, type: :feature
  config.include ExpectationHelper, type: :feature
  config.include Devise::TestHelpers, type: :controller

  config.raise_error_for_unimplemented_steps = true
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.before :each do
    stub_request(:post, /virus.scanner/).
      to_return(status: 200, body: { id: "de401fdf-08b0-44a8-810b-20794c5c98c7" }.to_json)

    # SENDGRID RELATED STUBS - BEGIN
    stub_request(:get, "https://sendgrid.com/api/spamreports.get.json?api_key=test_smtp_password&api_user=test_smtp_username&email=test@example.com").
      to_return(status: 200, body: "", headers: {})

    stub_sendgrid_bounced_emails_check_request("test@irrelevant.com")
    stub_sendgrid_bounced_emails_check_request("test@example.com")
    # SENDGRID RELATED STUBS - END

    AwardYear.current
  end
  config.infer_spec_type_from_file_location!
end

def stub_sendgrid_bounced_emails_check_request(email)
  stub_request(:get, "https://sendgrid.com/api/bounces.get.jsonapi_key=test_smtp_password&api_user=test_smtp_username&email=#{email}").
    to_return(status: 200, body: "", headers: {})
end
