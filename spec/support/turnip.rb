require "capybara/rspec"
require "capybara/rails"
require "turnip/capybara"

# Requires Turnip's steps
Dir.glob("spec/acceptance/steps/**/*steps.rb") { |f| load f, true }
