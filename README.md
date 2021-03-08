
![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) Queen's Awards for Enterprise
---------------------------

"QAE" is the application which powers the application process for The Queen's Awards for Enterprise.

## Setup

### Pre-requisites

* Ruby 2.5.6
* `gem install bundler -v 2.0.1`
* Rails 6.0
* Postgresql 9.5+
* Redis 2.8
* Cloudfountry Client

### Running application

```
./bin/setup
bundle exec rails s
bundle exec sidekiq -C config/sidekiq.yml
```

If you're running this on your local dev setup, start redis first before starting sidekiq

### Install Poxa

If you need to test collaborators editing the application at the same time, install poxa.

[https://gitlab.bitzesty.com/clients/qae/qae-poxa/blob/master/QAE_README.md#setup-on-local](https://gitlab.bitzesty.com/clients/qae/qae-poxa/blob/master/QAE_README.md#setup-on-local)

## Deploying

Continuous Deployment is setup and the application will automatically deploy after passing CI on the target branch (master, staging, production).

CF based PaaS is used for hosting [https://cloud.service.gov.uk](https://www.cloud.service.gov.uk/)

Follow these instructions to install in your dev env [https://www.notion.so/bitzesty/GDS-PaaS-Cloud-Foundry-CF-3ed30a317c5d4387acebe1a3529f6dfa](https://www.notion.so/bitzesty/GDS-PaaS-Cloud-Foundry-CF-3ed30a317c5d4387acebe1a3529f6dfa).


#### Dev

```bash
cf l # login to CLI tool, select space
cf target -o "beis-queens-awards-for-enterprise" -s dev # target a space
cf create-app-manifest qae-dev-worker
cf push -f qae-dev-worker_manifest.yml # deploy worker

cf create-app-manifest qae-dev
cf bgd qae-dev -f qae-dev_manifest.yml --delete-old-apps # deploy application with blue green deploy plugin
```


#### Staging

```bash
cf l # login to CLI tool, select space
cf target -o "beis-queens-awards-for-enterprise" -s staging # target a space
cf create-app-manifest qae-staging-worker
cf push -f qae-staging-worker_manifest.yml # deploy worker

cf create-app-manifest qae-staging
cf bgd qae-dev -f qae-staging_manifest.yml --delete-old-apps # deploy application with blue green deploy plugin
```


#### Production

```bash
cf l # login to CLI tool, select space
cf target -o "beis-queens-awards-for-enterprise" -s production # target a space
cf create-app-manifest qae-production-worker
cf push -f qae-production-worker_manifest.yml # deploy worker

cf create-app-manifest qae-production
cf bgd qae-dev -f qae-production_manifest.yml --delete-old-apps # deploy application with blue green deploy plugin
```



## Usefull commands

##### SSH

```bash
cf ssh qae-production
```

##### Logs

```bash
cf logs qae-production # for the stream
cf logs qae-production --recent # for recent log entries
```

Better logs in Papertrail for QAE.

https://papertrailapp.com

Login in 1password


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

## Check Cron schedule on live

https://www.queens-awards-enterprise.service.gov.uk/sidekiq/cron


## Profile mode in Development

To enable [rack mini profiler](https://github.com/MiniProfiler/rack-mini-profiler)
in development mode set in .env:
```
PROFILE_MODE=true
```
