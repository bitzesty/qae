source 'https://rubygems.org'

git_source(:github) { |name| "https://github.com/#{name}.git" }

ruby '~> 3.2.2'

gem 'rails', '7.0.8.1'
gem 'websocket-extensions', '~> 0.1.5'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL
gem 'pg'

# Track Changes
gem 'paper_trail', '~> 12.2.0'
gem 'paper_trail-association_tracking'

# Assets & Templates
gem 'sprockets', '~> 3.7.2'
gem 'sprockets-rails', '>= 2.0.0'
gem 'sassc-rails', '~> 2.1.2'
gem 'slim-rails', '~> 3.2.0'
gem 'coffee-rails', '5.0'
gem 'jquery-rails', '4.4.0'
gem 'jquery-ui-rails', '>= 7.0.0'
gem 'bootstrap-sass', '~> 3.4'
gem 'govuk-components'
gem 'uglifier', '>= 2.7.2'
gem 'js_cookie_rails', '2.1.4'
gem 'ckeditor'
gem 'webpacker', '6.0.0.rc.6'

# Autolinking in admin mass user mailer
gem 'rails_autolink'

# Decorators & Exposing named methods
gem 'draper', '~> 4.0'
gem 'decent_exposure'

gem 'hashie', '~> 3.5'

# Rails 4 Responders
gem 'responders', '~> 3.0'

# Rails 4 sanitizer
gem 'rails-html-sanitizer', '~> 1.4.4'

# JSON
gem 'json'
gem 'jbuilder', '~> 2.10.1'
gem 'gon', '>= 6.4.0'

# XLSX generation
gem 'rubyXL', '~> 3.4'

# User authentication & authorization
gem 'devise', '~> 4.9'
gem 'devise-authy', '>= 1.10.0'
gem 'pundit', '~> 0.3'
gem 'devise_zxcvbn', '>= 4.4.1'
gem 'devise-security', '~> 0.18.0'

# GOV.UK Notify support (for mailers)
gem 'mail-notify', '~> 1.0'

# Pagenation
gem 'kaminari'

# step-by-step wizard
gem 'wicked', '~> 1.1'

# Statemachine
gem 'statesman', '3.5.0'

# Form & Data helpers
gem 'simple_form', '~> 5.0'
gem 'country_select', '~> 3.1'
gem 'email_validator'
gem 'enumerize'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'nokogiri'

# Uploads
gem 'carrierwave', '~> 1.3'
gem "fog-aws"
gem 'vigilion', '~> 1.0.4'
gem 'vigilion-rails', '~> 2.2.0'

# Background jobs
gem "sidekiq", "~> 6.5.10"
gem "sidekiq-cron", "~> 1.1"
gem 'sinatra', '3.0.5', require: nil
gem 'rack-protection', '3.0.5'

# CORS configuration
gem 'rack-cors', '~> 1.0'

# Redis
gem 'redis-rails'
gem 'redis-store', "~> 1.4"

# We use it for communicating with api.debounce.io
gem 'rest-client'

# We are using Pusher with Poxa server
# for collaborators application edit stuff
#
gem 'pusher', '0.15.2'

# Text Search
gem 'pg_search', "~> 2.3.3"

# YAML/Hash loading
gem 'active_hash'
gem 'virtus'
gem 'nilify_blanks'

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb', '0.9.10'

# Web server
gem 'puma', '~> 6.4.2'

# Performance & Error reporting
gem 'appsignal'

# Log formatting
gem 'lograge'

# speedup server boot time
gem 'bootscale', require: false

gem 'browser', '2.4.0'

# Simple colored logging
gem 'shog'

gem 'rails-healthcheck'

gem 'matrix'

# Used to convert HTML to text, with the exception of whitelisted attributes.
# This makes it easier for us to display HTML content within PDF documents.
gem 'sanitize'

group :development do
  gem 'letter_opener'
  gem 'rack-mini-profiler', '>= 0.10.1', require: false
  gem 'binding_of_caller'
  gem 'rubocop', '~> 0.52', require: false
  # When need to copy model with nested associations
  gem 'amoeba', '3.0.0'
  # for RailsPanel Chrome extension
  gem 'listen'

  # Fixes https://github.com/rails/rails/issues/26658#issuecomment-255590071
  gem 'rb-readline'
end

group :development, :test do
  # Enviroment variables
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'rspec-github', require: false
  gem "pry-byebug"
  gem 'rails-controller-testing'
  gem "selenium-webdriver"
end

group :production do
  # Log to the STDOUT and dev/prod parity when delivering assets, 12factor.net
  gem 'rails_12factor', '~> 0.0.3'
end

group :test do
  gem 'factory_bot_rails'
  gem 'capybara', '~> 3.39.0'
  gem 'poltergeist'
  gem 'database_cleaner-active_record'
  gem 'launchy'
  gem 'turnip', '~> 4.2.0'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate_circle_ci_coverage'
  gem 'rspec_junit_formatter', '0.2.3'
  gem 'timecop'
  gem 'webmock', '3.18.1'
  gem 'rspec-sidekiq'
end
