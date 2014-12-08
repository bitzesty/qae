ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'database_cleaner'
require 'shoulda/matchers'

Capybara.javascript_driver = :webkit
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| load f, true}

ActiveRecord::Migration.maintain_test_schema!
Qae::Application.load_tasks

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.raise_error_for_unimplemented_steps = true
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
end
