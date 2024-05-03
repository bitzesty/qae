# frozen_string_literal: true

require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"

Capybara.server = :puma # , { Silent: true }

Capybara.register_driver(:chrome_headless) do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless") if ENV["TEST_IN_BROWSER"].nil?
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

# Capybara.default_driver = :chrome_headless
Capybara.javascript_driver = :chrome_headless
Capybara.default_max_wait_time = 5
