FROM convox/rails

ENV SSL_CERT_DIR=/etc/ssl/certs
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN apt-get update && apt-get install -y ca-certificates \
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
    postgresql-dev \
    postgresql

RUN update-ca-certificates

EXPOSE 3000

WORKDIR /app

# Cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle install --without development test --jobs 4

# copy just the files needed for assets:precompile
COPY Rakefile   /app/Rakefile
COPY config     /app/config
COPY public     /app/public
COPY app/assets /app/app/assets
COPY lib        /app/lib
COPY app/models /app/app/models

ENV RAILS_ENV production
ENV DATABASE_URL postgresql://localhost/dummy_url
ENV AWS_ACCESS_KEY_ID dummy
ENV AWS_SECRET_ACCESS_KEY dummy

RUN bundle exec rake assets:precompile --trace

# Copy the rest of the app
COPY . /app
