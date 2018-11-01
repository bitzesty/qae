source 'https://rubygems.org'

ruby '2.5.0'

gem 'rails', '5.0.2'

# Security HTTP Headers
gem 'secure_headers', '2.0.0'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL
gem 'pg', '~> 0.17'

# Track Changes
gem 'paper_trail', '~> 5.1.0'

# Assets & Templates
gem 'sprockets-rails', '>= 2.0.0'
gem 'slim-rails', '3.1.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '>= 3.3.3'
gem 'govuk_frontend_toolkit', '~> 3.1.0'
gem 'govuk_template', '0.12.0'
gem 'uglifier', '>= 2.7.2'
gem 'js_cookie_rails', '~> 2.1'
gem 'ckeditor', github: 'galetahub/ckeditor', ref: "752bca97f78e5c5df3fbd876e51a06918da804e2"

# Autolinking in admin mass user mailer
gem 'rails_autolink'

# Decorators & Exposing named methods
gem 'draper'
gem 'decent_exposure'
gem 'decent_decoration'

gem 'hashie'

# Rails 4 Responders
gem 'responders', '~> 2.0'

# Rails 4 sanitizer
gem 'rails-html-sanitizer', '~> 1.0.4'

# JSON
gem 'jbuilder', '~> 2.0'
gem 'gon'

# User authentication & authorization
gem 'devise', '4.4.0'
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
gem 'simple_form', '~> 3.5'
gem 'country_select'
gem 'email_validator'
gem 'enumerize', '~> 0.8'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'nokogiri', '~> 1.8.4'

# Uploads
gem 'carrierwave', '~> 1.2'
gem "jquery.fileupload-rails", github: "bitzesty/jquery.fileupload-rails"
gem "fog"
gem "fog-aws"
gem 'vigilion', '~> 1.0.4'
gem 'vigilion-rails', '~> 1.0.5'

# Background jobs
gem "sidekiq", "~> 4.1.1"
gem "sidekiq-cron", "~> 0.4.2"
gem 'sinatra', '2.0.0', require: nil
gem "rack-protection"

# Redis
gem 'redis-rails'
gem 'redis-store', "~> 1.4"

# We are using Pusher with Poxa server
# for collaborators application edit stuff
#
gem "pusher"

# Text Search
gem 'pg_search', "0.7.9"

# YAML/Hash loading
gem 'active_hash'
gem 'virtus'
gem 'nilify_blanks'

# Monitoring
gem 'skylight'

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb'

# Web server
gem 'puma', '3.11.0'

# Log formatting
gem 'lograge'

# speedup server boot time
gem 'bootscale', require: false

gem 'browser'

group :development do
  gem 'letter_opener'
  gem 'rack-mini-profiler', '>= 0.10.1', require: false
  gem 'binding_of_caller'
  gem 'rubocop', '~> 0.52', require: false
  # When need to copy model with nested associations
  gem 'amoeba'
  # for RailsPanel Chrome extension
  gem 'meta_request'
end

group :development, :test do
  # Enviroment variables
  gem 'dotenv-rails'
  gem 'rspec-rails', '3.5'
  gem "pry-byebug"
end

group :production do
  # Error reporting
  gem 'sentry-raven'
  # Log to the STDOUT and dev/prod parity when delivering assets, 12factor.net
  gem 'rails_12factor', '~> 0.0.3'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'turnip', '3.0.0'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate_circle_ci_coverage'
  gem 'rspec_junit_formatter', '0.3.0'
  gem 'timecop'
  gem 'webmock'
  gem 'rspec-sidekiq'
end
