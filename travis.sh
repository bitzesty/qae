#!/bin/sh

set +e

RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
RAILS_ENV=test bundle exec rspec spec --tag "~skip_travis"
rv=$?

exit $rv
