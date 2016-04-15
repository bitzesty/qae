FROM ruby:2.3.0-alpine

RUN apk add --update --no-cache \
    build-base \
    perl \
    curl \
    curl-dev \
    nodejs \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    git \
    postgresql-client \
    postgresql-dev
RUN bundle config build.nokogiri --use-system-libraries

EXPOSE 3000

WORKDIR /app

# Cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Otherwise we need QT for capybara-webkit
RUN bundle install --without test

# Copy the rest of the app
COPY . /app

RUN RAILS_ENV=production ONLY_ASSETS=true bundle exec rake assets:precompile
