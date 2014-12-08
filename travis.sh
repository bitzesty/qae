#!/bin/sh

set +e

bundle exec rspec spec --tag ~skip_travis
rv=$?

exit $rv
