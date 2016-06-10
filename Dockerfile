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
RUN bundle install --without development test --jobs 4

# Copy the rest of the app
COPY . /app

ENV RAILS_ENV=production
ENV ONLY_ASSETS=true

RUN bundle exec rake assets:precompile --trace
