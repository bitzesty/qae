source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.2'

# Security HTTP Headers
gem 'secure_headers'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL
gem 'pg', '~> 0.17'

# Track Changes
gem 'paper_trail', '~> 5.1.0'

# Assets & Templates
gem 'slim-rails', '~> 3.0.1'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '>= 3.3.3'
gem 'govuk_frontend_toolkit', github: 'alphagov/govuk_frontend_toolkit_gem',
                              submodules: true
gem 'govuk_template', '0.12.0'
gem 'uglifier', '>= 1.3.0'

# Autolinking in admin mass user mailer
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

group :staging, :production do
  # Error reporting
  gem 'sentry-raven', github: 'getsentry/raven-ruby'
  # Log to the STDOUT and dev/prod parity when delivering assets, 12factor.net
  gem 'rails_12factor', '~> 0.0.3'
end

# Uploads
gem 'carrierwave'
gem "jquery.fileupload-rails", github: "bitzesty/jquery.fileupload-rails"
gem "fog"
gem "fog-aws"
gem 'vigilion'
gem 'vigilion-rails'

# Background jobs
gem "sidekiq", "~> 4.1.1"
gem "sidekiq-cron", "~> 0.4.2"

# Redis
gem 'redis-rails'
gem 'redis-store'

# Text Search
gem 'pg_search'

# YAML/Hash loading
gem 'active_hash'
gem 'virtus'
gem 'nilify_blanks'

# Monitoring
gem 'newrelic_rpm'

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb'

gem 'puma', '~> 2.16.0'

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'turnip'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rspec_junit_formatter'
  gem 'timecop'
  gem 'webmock'
end

group :development do
  gem 'pry'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rack-mini-profiler', require: false
  gem 'binding_of_caller'
  gem 'rubocop', require: false
  # When need to copy model with nested associations
  gem 'amoeba'
end

group :development, :test do
  # Enviroment variables
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.4'
end
