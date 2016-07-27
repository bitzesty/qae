[![Circle CI](https://circleci.com/gh/bitzesty/qae.svg?style=svg)](https://circleci.com/gh/bitzesty/qae)
[![Code Climate](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/gpa.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)
[![Test Coverage](https://codeclimate.com/repos/547de5166956803114000f02/badges/123ad2d3eeebb6bf1ce1/coverage.svg)](https://codeclimate.com/repos/547de5166956803114000f02/feed)

![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) Queen's Awards for Enterprise
---------------------------

"QAE" is the application which powers the application process for The Queen's Awards for Enterprise.

## Setup

### Pre-requisites

* Ruby 2.3.1
* Rails 4.2
* Postgresql 9.4
* Redis 2.8

### Running application

```
./bin/setup
foreman start
```

### Running with convox locally

Install docker, and install convox

```
convox start -f docker-compose.yml.local
docker exec qae-web bundle exec rake db:schema:load db:migrate db:seed
```

### Deploying

Continuous Deployment is setup and the application will automatically deploy after passing CI on the target branch (master, staging, deployment).

You can run a manual deploy if needed:

```
convox switch bitzesty/qae

convox deploy -a qae-dev
```

You may also need to run a rake task for database migrations manually:

```
convox run web rake db:migrate -a qae-dev
```

#### Dev

```
convox deploy -a qae-dev
convox run web rake db:migrate -a qae-dev
```

#### Staging

```
convox deploy -a qae-staging
convox run web rake db:migrate -a qae-staging
```

#### Production

```
convox deploy -a qae-production
convox run web rake db:migrate -a qae-production
```

#### Usefull commands

##### Rails console

```
convox run web rails console -a <CONVOX_APP>
```

##### Logs

```
convox logs -a <CONVOX_APP>
```

Filtering by key word and date.
```
convox logs -a qae-qev --filter=SubmissionDeadlineApplicationPdfGenerationWorker --since=27h
```
In this example it fetches logs for latest 27 h with keyword "SubmissionDeadlineApplicationPdfGenerationWorker"

Better logs in Papertrail for QAE.

https://papertrailapp.com

Login in last pass

##### Deploy without cache

```
convox deploy -a <CONVOX_APP> --no-cache
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
