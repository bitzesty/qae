[![Build Status](https://travis-ci.org/bitzesty/qae.svg?branch=master)](https://travis-ci.org/bitzesty/qae)
[![Code Climate](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/gpa.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)
[![Test Coverage](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/coverage.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)

![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) Queen's Awards for Enterprise
---------------------------

"QAE" is the application which powers the application process for the Queen's Awards for Enterprise.

## Setup

### Pre-requisites

* Ruby 2.1.5
* Rails 4.2
* Postgresql 9
* Redis

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

### Deploy

#### Dev (http://qae.dev.bitzesty.com)

```
$ cap dev deploy OLD_SERVERS=true
```

#### Demo (http://qae.demo.bitzesty.com)

```
$ cap demo deploy OLD_SERVERS=true
```

#### Staging (http://stagingloadbalancer-46995185.eu-west-1.elb.amazonaws.com)
```
$ cap staging deploy
```

#### Production (http://productionloadbalancer-1868729055.eu-west-1.elb.amazonaws.com)
```
$ cap production deploy
```

#### For running custom rake tasks you can use:

```ruby
  cap env deploy:invoke[namespace:task_name]
```

For example:

```ruby
  cap dev deploy:invoke[db:migrate] OLD_SERVERS=true
  cap staging deploy:invoke[db:migrate]
