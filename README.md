[![Circle CI](https://circleci.com/gh/bitzesty/qae.svg?style=svg)](https://circleci.com/gh/bitzesty/qae)
[![Code Climate](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/gpa.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)
[![Test Coverage](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/coverage.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)

![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) Queen's Awards for Enterprise
---------------------------

"QAE" is the application which powers the application process for The Queen's Awards for Enterprise.

## Setup

### Pre-requisites

* Ruby 2.1.5
* Rails 4.2
* Postgresql 9
* Redis

### NOTES

Please, do not update Rails from 4.2.0 to 4.2.1 as it cause sprockets / capistrano conflict:
```
cp: cannot stat ‘/home/qae/application/releases/20150414082336/public/assets/manifest*’: No such file or directory
cap aborted!
SSHKit::Runner::ExecuteError: Exception while executing on host 95.138.174.112: cp exit status: 1
cp stdout: Nothing written
cp stderr: cp: cannot stat ‘/home/qae/application/releases/20150414082336/public/assets/manifest*’: No such file or directory
```
and to fix it we need to upgrade capistrano stuff (gems/ configuration) which can take more time.
So probably let's put upgrade Rails  on hold for now.

### Running application

```
./bin/setup
foreman start
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

For passenger:
OSX users you might need to install pcre headers:

```
brew install pcre
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

## Hide Application's PDF links anythere on Applicant view

Uncomment following line in config/environments/production.rb:
```
Rails.configuration.hide_pdf_links = true
```
and all PDF blocks on Applicant's view would be automatically replaced with
maintenance messages and PDF links would be hidden.
