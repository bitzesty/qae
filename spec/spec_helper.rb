ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.raise_error_for_unimplemented_steps = true
  config.use_transactional_fixtures = false

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
