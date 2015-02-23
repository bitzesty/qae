source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'

# PostgreSQL
gem 'pg', '~> 0.17'

# Envrioment variables
gem 'dotenv-rails', '~> 1.0'

# Assets & Templates
gem 'slim-rails', '~> 3.0.1'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'bootstrap-sass', '>= 3.3.3'
gem 'govuk_frontend_toolkit', github: 'alphagov/govuk_frontend_toolkit_gem',
                              submodules: true
gem 'govuk_template', '0.12.0'

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

# User authentication & authorization
gem 'devise', '~> 3.4'
gem 'pundit', '~> 0.3'

# Pagenation
gem 'kaminari', '~> 0.16'

# step-by-step wizard
gem 'wicked', '~> 1.1'

# Statemachine
gem 'statesman'

# Form & Data helpers
gem 'simple_form', '~> 3.0'
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
gem 'jquery.fileupload-rails'

# Background jobs
gem 'sidekiq'
gem 'sidekiq-status'
gem 'sinatra', require: false

gem 'foreman'

group :assets do
  gem 'uglifier', '>= 1.3.0'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'turnip'
  gem 'shoulda-matchers', require: false
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'rspec-sidekiq'
  gem 'codeclimate-test-reporter', group: :test, require: nil
end

group :development do
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
  gem 'slackistrano', require: false
  gem 'pry'
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'rack-mini-profiler', require: false
  gem 'passenger'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'byebug'
end
