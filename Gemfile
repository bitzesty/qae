source 'https://rubygems.org'

ruby '2.5.0'

gem 'rails', '~> 5.2'

# Security HTTP Headers
gem 'secure_headers', '2.0.0'

# SSL redirect
gem 'rack-ssl-enforcer'

# PostgreSQL
gem 'pg', '~> 0.20'

# Track Changes
gem 'paper_trail', '~> 5.1.0'

# Assets & Templates
gem 'sprockets-rails', '>= 2.0.0'
gem 'slim-rails', '3.1.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'jquery-ui-rails', '5.0.3'
gem 'bootstrap-sass', '>= 3.3.3'
gem 'govuk_frontend_toolkit', '~> 3.1.0'
gem 'govuk_template', '0.12.0'
gem 'uglifier', '>= 2.7.2'
gem 'js_cookie_rails', '2.1.4'
gem 'ckeditor', github: 'galetahub/ckeditor', ref: "752bca97f78e5c5df3fbd876e51a06918da804e2"

# Autolinking in admin mass user mailer
gem 'rails_autolink'

# Decorators & Exposing named methods
gem 'draper'
gem 'decent_exposure'
gem 'decent_decoration'

gem 'hashie', '3.4.4'

# Rails 4 Responders
gem 'responders', '~> 2.0'

# Rails 4 sanitizer
gem 'rails-html-sanitizer', '~> 1.0.4'

# JSON
gem 'json', '1.8.6'
gem 'jbuilder', '~> 2.0'
gem 'gon'

# User authentication & authorization
gem 'devise'
gem 'devise-authy'
gem 'pundit', '~> 0.3'
gem 'devise_zxcvbn'

# Pagenation
gem 'kaminari'

# step-by-step wizard
gem 'wicked', '~> 1.1'

# Statemachine
gem 'statesman', '3.5.0'

# Form & Data helpers
gem 'simple_form'
gem 'country_select', '2.1.0'
gem 'email_validator'
gem 'enumerize'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'nokogiri', '1.8.4'

# Uploads
gem 'carrierwave', '~> 1.2'
gem 'jquery.fileupload-rails', github: 'bitzesty/jquery.fileupload-rails'
gem 'fog', "1.41.0"
gem "fog-aws"
gem 'vigilion', '~> 1.0.4'
gem 'vigilion-rails', github: "mechanicles/vigilion-rails", ref: "d149da396ef553f6959236c43960db97b6bbac36"

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
gem 'pusher', '0.15.2'

# Text Search
gem 'pg_search', "0.7.9"

# YAML/Hash loading
gem 'active_hash'
gem 'virtus'
gem 'nilify_blanks'

# We use it for sending API requests to Sendgrid in
# AdvancedEmailValidator
gem 'curb', '0.8.8'

# Web server
gem 'puma', '3.11.0'

# Log formatting
gem 'lograge'

# speedup server boot time
gem 'bootscale', require: false

gem 'browser', '2.4.0'

group :development do
  gem 'letter_opener'
  gem 'rack-mini-profiler', '>= 0.10.1', require: false
  gem 'binding_of_caller'
  gem 'rubocop', '~> 0.52', require: false
  # When need to copy model with nested associations
  gem 'amoeba', '3.0.0'
  # for RailsPanel Chrome extension
  gem 'meta_request'
  gem 'listen'
end

group :development, :test do
  # Enviroment variables
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem "pry-byebug"
  gem 'rails-controller-testing'
end

group :production do
  # Error reporting
  gem 'sentry-raven'
  # Log to the STDOUT and dev/prod parity when delivering assets, 12factor.net
  gem 'rails_12factor', '~> 0.0.3'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '2.7.1'
  gem 'poltergeist'
  gem 'database_cleaner', '1.6.1'
  gem 'launchy'
  gem 'turnip', '3.0.0'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'codeclimate_circle_ci_coverage'
  gem 'rspec_junit_formatter', '0.2.3'
  gem 'timecop'
  gem 'webmock', '3.3.0'
  gem 'rspec-sidekiq'
end
