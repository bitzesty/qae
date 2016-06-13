FROM ruby:2.3.1-alpine

ENV SSL_CERT_DIR=/etc/ssl/certs
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN apk add --update --no-cache \
    ca-certificates \
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

RUN update-ca-certificates

EXPOSE 3000

WORKDIR /app

# Cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test --jobs 4

# Copy the rest of the app
COPY . /app

ENV RAILS_ENV=production
ENV DATABASE_URL postgresql://localhost/dummy_url

RUN ONLY_ASSETS=true bundle exec rake assets:precompile --trace
