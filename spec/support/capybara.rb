# frozen_string_literal: true

require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"

Capybara.register_driver(:chrome_headless) do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless") if ENV["TEST_IN_BROWSER"].nil?
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,1400")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.register_server :puma do |app, port, host, options = {}|
  require "rack/handler/puma"
  puma_options = { Host: host, Port: port, Threads: "0:1", workers: 0, daemon: false }
  Rack::Handler::Puma.run(app, **puma_options.merge(options))
end

Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.default_normalize_ws = true
  config.disable_animation = true
  config.enable_aria_label = true
  config.server = :puma
end

Capybara.javascript_driver = :chrome_headless
