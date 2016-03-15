[![Circle CI](https://circleci.com/gh/bitzesty/qae.svg?style=svg)](https://circleci.com/gh/bitzesty/qae)
[![Code Climate](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/gpa.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)
[![Test Coverage](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/coverage.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)

![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) Queen's Awards for Enterprise
---------------------------

"QAE" is the application which powers the application process for The Queen's Awards for Enterprise.

## Setup

### Pre-requisites

* Ruby 2.3.0
* Rails 4.2
* Postgresql 9
* Redis

### NOTES

### Running application

```
./bin/setup
foreman start
```

### Running with convox

```
convox start
docker exec qae-web bundle exec rake db:schema:load db:migrate db:seed
```

#### Help

If you see the following error:

```
ActiveRecord::StatementInvalid: PG::UndefinedFile: ERROR:  could not open extension control file "/usr/share/postgresql/9.3/extension/hstore.control": No such file or directory
: CREATE EXTENSION IF NOT EXISTS "hstore"

```

This means, that `hstore postgresql` extension needs to be installed:

```
sudo apt-get install postgresql-contrib
```

## Profile mode in Development

To enable [rack mini profiler](https://github.com/MiniProfiler/rack-mini-profiler)
in development mode set in .env:
```
PROFILE_MODE=true
```

## Users import
```
  rake users_import:import_from_csv FILEPATH="./spec/fixtures/users.csv"
```
