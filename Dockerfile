# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

ENV HOME=/home/rails
ENV USER=rails

# Set default to production, but allow override
ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

# Set production environment
ENV BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    PATH="/usr/local/bundle/bin:$PATH"

# Conditionally set bundle config based on RAILS_ENV
RUN if [ "$RAILS_ENV" = "production" ]; then \
    echo "Setting production bundle config"; \
    bundle config set --local deployment 'true'; \
    bundle config set --local without 'development test'; \
    else \
    echo "Setting development bundle config"; \
    bundle config set --local deployment 'false'; \
    fi

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

# Install packages needed for both production and development
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y curl build-essential libpq-dev libvips node-gyp pkg-config python-is-python3 imagemagick libjemalloc2 postgresql-client

# Install Node.js
ARG NODE_VERSION=20.16.0
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    rm -rf /tmp/node-build-master

# Install yarn
ARG YARN_VERSION=1.22.22
RUN npm install -g yarn@$YARN_VERSION

# Copy application code
COPY . .
RUN chmod +x /rails/bin/*

# Install dependencies
COPY --link Gemfile Gemfile.lock ./
RUN bundle install

# Install node modules
COPY --link package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN if [ "$RAILS_ENV" = "production" ]; then \
    SECRET_KEY_BASE=DUMMY ./bin/rails assets:precompile; \
    fi

# Create rails user and set correct permissions
RUN groupadd -r rails && useradd -r -g rails rails
RUN mkdir -p $HOME && chown -R $USER:$USER $HOME /rails

# Verify user creation and permissions
RUN id rails && ls -la /rails/bin

# Switch to rails user
USER $USER

# Add this line to ensure the HOME env is available to all processes
ENV HOME=$HOME

# Deployment options
ENV LD_PRELOAD="libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
    RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RUBY_YJIT_ENABLE="1"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]