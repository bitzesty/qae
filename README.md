## ![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) King's Awards for Enterprise

"QAE" is the application which powers the application process for The King's Awards for Enterprise.

# Setup

## Pre-requisites

- Ruby 2.7.7
- `gem install bundler -v 2.4.8`
- Rails 6.1
- Postgresql 9.5+
- Redis 2.8
- Cloudfountry Client

### Running application

```
./bin/setup
bundle exec rails s
bundle exec sidekiq -C config/sidekiq.yml
```

If you're running this on your local dev setup, start redis first before starting sidekiq

### Running with docker

    $ cp Dockerfile.local Dockerfile
    $ cp docker-compose.yml.local docker-compose.yml
    $ docker-compose up

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

### Install Poxa

If you need to test collaborators editing the application at the same time, install poxa.

# Deploying

Continuous Deployment is setup and the application will automatically deploy after passing CI on the target branch (main, staging, production). For more details see the Github Actions.

CF based GOV.UK PaaS is used for hosting [https://cloud.service.gov.uk](https://www.cloud.service.gov.uk/).

# License

qae is Copyright © 2014 Crown Copyright & Bit Zesty. It is free
software, and may be redistributed under the terms specified in the
[LICENSE] file.

[license]: https://github.com/bitzesty/qae/blob/master/LICENSE

# About Bit Zesty

![Bit Zesty](https://bitzesty.com/wp-content/uploads/2017/01/logo_dark.png)

qae is maintained by Bit Zesty LTD.
The names and logos for Bit Zesty are trademarks of Bit Zesty LTD.

See [our other projects](https://bitzesty.com/client-stories/) or
[hire us](https://bitzesty.com/contact/) to design, develop, and support your product or service.
