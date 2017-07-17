FROM convox/rails

ENV HOME=/app
WORKDIR /app

ENV SSL_CERT_DIR=/etc/ssl/certs
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENV CURL_CONNECT_TIMEOUT=0 CURL_TIMEOUT=0 GEM_PATH="$HOME/vendor/bundle/ruby/2.3.1:$GEM_PATH" LANG=${LANG:-en_US.UTF-8} PATH="$HOME/bin:$HOME/vendor/bundle/bin:$HOME/vendor/bundle/ruby/2.3.1/bin:$PATH" RACK_ENV=${RACK_ENV:-production} RAILS_ENV=${RAILS_ENV:-production} RAILS_SERVE_STATIC_FILES=${RAILS_SERVE_STATIC_FILES:-enabled} SECRET_KEY_BASE=${SECRET_KEY_BASE:-PLACEHOLDERSECRETBASEKEY}

# Cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test --jobs 4

COPY . /app

ENV DATABASE_URL postgresql://localhost/dummy_url
ENV AWS_ACCESS_KEY_ID dummy
ENV AWS_SECRET_ACCESS_KEY dummy

RUN RAILS_ENV=production bundle exec rake assets:precompile
