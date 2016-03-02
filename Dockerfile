FROM gliderlabs/alpine:3.3

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base git" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev libffi-dev tzdata yaml-dev libpq curl qt5-qtbase qt5-qtbase-dev qt5-qtwebkit-dev postgresql-client postgresql-dev" \
    RUBY_PACKAGES="ruby ruby-irb ruby-io-console ruby-bigdecimal ruby-json yaml nodejs" \
    RAILS_VERSION="4.2.5.1" \
    PATH="$PATH:/usr/lib/qt5/bin/"

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $RUBY_PACKAGES $DEV_PACKAGES && \
  gem install -N bundler && \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/*

RUN echo 'gem: --no-document' >> ~/.gemrc && \
  gem install -N nokogiri -- --use-system-libraries && \
  gem install -N rails --version "$RAILS_VERSION" && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \

  # cleanup and settings
  bundle config --global build.nokogiri  "--use-system-libraries" && \
  bundle config --global build.nokogumbo "--use-system-libraries" && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem

EXPOSE 3000

WORKDIR /app

# cache bundler
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# copy the rest of the app
COPY . /app
