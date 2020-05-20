source 'https://rubygems.org'

git_source(:github) { |name| "https://github.com/#{name}.git" }

ruby '~> 2.5.6'

gem 'rails', '~> 5.2.4.3'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL
gem 'pg', '~> 0.20'

# Track Changes
gem 'paper_trail', '~> 10.3', '>= 10.3.0'

# Assets & Templates
gem 'sprockets', '~> 3.7.2'
gem 'sprockets-rails', '>= 3.2.1'
gem 'slim-rails', '3.1.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.5'
gem 'jquery-ui-rails', '6.0.1'
gem 'bootstrap-sass', '~> 3.4'
gem 'govuk_frontend_toolkit', '~> 3.1.0'
gem 'govuk_template', '0.12.0'
gem 'uglifier', '>= 2.7.2'
gem 'js_cookie_rails', '2.1.4'
gem 'ckeditor', github: 'galetahub/ckeditor', ref: "752bca97f78e5c5df3fbd876e51a06918da804e2"

# Autolinking in admin mass user mailer
gem 'rails_autolink', '>= 1.1.6'

# Decorators & Exposing named methods
gem 'draper', '>= 3.0.1'
gem 'decent_exposure', '>= 3.0.2'
gem 'decent_decoration', '>= 0.1.0'

gem 'hashie', '3.4.4'

# Rails 4 Responders
gem 'responders', '~> 2.4', '>= 2.4.1'

# Rails 4 sanitizer
gem 'rails-html-sanitizer', '~> 1.3.0'

# JSON
gem 'json', '2.3.0'
gem 'jbuilder', '~> 2.8', '>= 2.8.0'
gem 'gon', '>= 6.2.1'

# User authentication & authorization
gem 'devise', '~> 4.7', '>= 4.7.1'
gem 'devise-authy', '>= 1.10.0'
gem 'pundit', '~> 0.3', '>= 0.3.0'
gem 'devise_zxcvbn', '>= 4.4.1'
gem 'devise-security', github: "rusllonrails/devise-security", branch: "V_0_13_0_with_skip_limitable_patch"

# GOV.UK Notify support (for mailers)
gem 'mail-notify', '>= 0.0.3'

# Pagenation
gem 'kaminari', '>= 1.1.1'

# step-by-step wizard
gem 'wicked', '~> 1.3', '>= 1.3.3'

# Statemachine
gem 'statesman', '3.5.0'

# Form & Data helpers
gem 'simple_form', '~> 5.0', '>= 5.0.1'
gem 'country_select', '~> 3.1'
gem 'email_validator', '>= 1.6.0'
gem 'enumerize', '>= 2.2.2'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'nokogiri', '~> 1.10.9'

# Uploads
gem 'carrierwave', '~> 1.2', '>= 1.2.3'
gem 'fog', "1.42.1"
gem "fog-aws"
gem 'vigilion', '~> 1.0.4'
gem 'vigilion-rails', '>= 2.0.0'

# Background jobs
gem "sidekiq", "~> 5.2"
gem "sidekiq-cron", "~> 1.1"
gem 'sinatra', '~> 2.0', require: nil
gem "rack-protection"

# CORS configuration
gem 'rack-cors', '~> 1.0'

# Redis
gem 'redis-rails', '>= 5.0.2'
gem 'redis-store', "~> 1.4"

# We use it for communicating with api.debounce.io
gem 'rest-client'

# We are using Pusher with Poxa server
# for collaborators application edit stuff
#
gem 'pusher', '0.15.2'

# Text Search
gem 'pg_search', '0.7.9'

# YAML/Hash loading
gem 'active_hash', '>= 2.1.0'
gem 'virtus'
gem 'nilify_blanks', '>= 1.3.0'

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb', '0.9.10'

# Web server
gem 'puma', '~> 4.3.3'

# Performance
gem 'scout_apm'

# Log formatting
gem 'lograge', '>= 0.10.0'

# speedup server boot time
gem 'bootscale', require: false

gem 'browser', '2.4.0'

# Simple colored logging
gem 'shog', '>= 0.2.1'

group :development do
  gem 'letter_opener'
  gem 'rack-mini-profiler', '>= 0.10.1', require: false
  gem 'binding_of_caller'
  gem 'rubocop', '~> 0.52', require: false
  # When need to copy model with nested associations
  gem 'amoeba', '3.0.0'
  # for RailsPanel Chrome extension
  gem 'meta_request', '>= 0.6.0'
  gem 'listen'

  # Fixes https://github.com/rails/rails/issues/26658#issuecomment-255590071
  gem 'rb-readline'
end

group :development, :test do
  # Enviroment variables
  gem 'dotenv-rails', '>= 2.5.0'
  gem 'rspec-rails', '>= 3.8.1'
  gem "pry-byebug"
  gem 'rails-controller-testing', '>= 1.0.2'
  gem "selenium-webdriver"
end

group :production do
  # Error reporting
  gem 'sentry-raven'
  # Log to the STDOUT and dev/prod parity when delivering assets, 12factor.net
  gem 'rails_12factor', '~> 0.0.3'
end

group :test do
  gem 'factory_girl_rails', '>= 4.9.0'
  gem 'capybara', '3.18'
  gem 'poltergeist'
  gem 'database_cleaner', '1.6.1'
  gem 'launchy'
  gem 'turnip', '3.0.0'
  gem 'shoulda-matchers', '>= 3.1.2', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate_circle_ci_coverage'
  gem 'rspec_junit_formatter', '0.2.3'
  gem 'timecop'
  gem 'webmock', '3.3.0'
  gem 'rspec-sidekiq'
end
