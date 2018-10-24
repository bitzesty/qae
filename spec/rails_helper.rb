ENV["RAILS_ENV"] ||= "test"

require "simplecov"
require "codeclimate-test-reporter"
SimpleCov.add_filter "vendor"

# SimpleCov.formatters = []
#
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

require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "capybara/rspec"
require "shoulda/matchers"
require "webmock/rspec"
require 'capybara/poltergeist'

Dotenv.overload('.env.test')

WebMock.disable_net_connect!(allow: "codeclimate.com", allow_localhost: true)

# Require all support files.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

options = {
  js_errors: false,
  timeout: 240,
  phantomjs_options: [
    '--load-images=no',
    '--ignore-ssl-errors=yes'
  ]
}
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.javascript_driver = :poltergeist

ActiveRecord::Migration.check_pending!
ActiveRecord::Migration.maintain_test_schema!
Qae::Application.load_tasks

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UserStepDefinitions, type: :feature
  config.include ExpectationHelper, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.raise_error_for_unimplemented_steps = true
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.before :each do
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
