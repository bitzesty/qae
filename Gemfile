source 'https://rubygems.org'

gem 'rails', '4.2.5.2'

# Security HTTP Headers
gem 'secure_headers'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL
gem 'pg', '~> 0.17'

# Track Changes
gem 'paper_trail', '~> 4.1.0'

# Envrioment variables
gem 'dotenv-rails', '~> 1.0'

# Assets & Templates
gem 'slim-rails', '~> 3.0.1'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '>= 3.3.3'
gem 'govuk_frontend_toolkit', github: 'alphagov/govuk_frontend_toolkit_gem',
                              submodules: true
gem 'govuk_template', '0.12.0'
gem 'rails_autolink'

# Decorators & Exposing named methods
gem 'draper'
gem 'decent_exposure'
gem 'decent_decoration'

# Rails 4 Responders
gem 'responders', '~> 2.0'

# Rails 4 sanitizer
gem 'rails-html-sanitizer'

# JSON
gem 'jbuilder', '~> 2.0'
gem 'gon'

# User authentication & authorization
gem 'devise', '~> 3.4'
gem 'devise-authy'
gem 'pundit', '~> 0.3'
gem 'devise_zxcvbn'

# Pagenation
gem 'kaminari', '~> 0.16'

# step-by-step wizard
gem 'wicked', '~> 1.1'

# Statemachine
gem 'statesman'

# Form & Data helpers
gem 'simple_form', '~> 3.1'
gem 'country_select'
gem 'email_validator'
gem 'enumerize', '~> 0.8'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'nokogiri', '~> 1.6.0'

# Error reporting
gem 'sentry-raven', github: 'getsentry/raven-ruby'

# Uploads
gem 'carrierwave'
gem "jquery.fileupload-rails", github: "bitzesty/jquery.fileupload-rails"
gem "fog"
gem "fog-aws"
gem 'vigilion', github: "vigilion/vigilion-ruby"
gem 'vigilion-rails', github: "vigilion/vigilion-rails"

# Background jobs
gem "sidekiq", "~> 4.1.1"
gem "sidekiq-cron", "~> 0.4.2"

# Redis
gem 'redis-rails'
gem 'redis-store'

# Process manager
gem 'foreman'

# Text Search
gem 'pg_search'

# YAML/Hash loading
gem 'active_hash'
gem "virtus"
gem "nilify_blanks"

# Monitoring
gem 'newrelic_rpm'
gem "tilt", "~> 1.1"

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb'

gem 'rails_12factor', '~> 0.0.3', group: :production
gem 'puma', '~> 2.16.0'

group :assets do
  gem 'uglifier', '>= 1.3.0'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'turnip'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate-test-reporter', group: :test, require: nil
  gem "timecop"
  gem "webmock"
end

group :development do
  gem 'pry'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rack-mini-profiler', require: false
  gem 'binding_of_caller'
  gem 'rubocop', require: false
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'byebug'
  gem "rspec_junit_formatter"
end

group :development, :staging do
  # When need to copy model with nested associations
  gem 'amoeba'
end
