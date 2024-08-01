# ![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) King's Awards for Enterprise

"QAE" is the application which powers the application process for The King's Awards for Enterprise.

## Development

### Prerequisites

- Ruby 3.2.2
  - `gem install bundler -v 2.5.6`
- Node.js
- Rails 7.0
- Postgresql 9.5+ with `hstore` extension
- Redis 4+

### Running the application

There are environment variables that you may want to modify in the `.env` file.

```
cp .env.example .env
```

Ensure the postgres database and redis server are running.

```
./bin/setup
```

Run the application with the following commands:

```
bundle exec rails s
bundle exec sidekiq -C config/sidekiq.yml
```

or with foreman:

```
foreman start
```

### Running with docker

    $ cp Dockerfile.local Dockerfile
    $ cp docker-compose.yml.local docker-compose.yml
    $ docker-compose up

### Installing Poxa

If you need to test collaborators editing the application at the same time, install [poxa](https://github.com/bitzesty/poxa).

### Installing Malware Scanning

Files are uploaded to S3 and then scanned with ClamAV via the Vigilion service.

If you need to test malware scanning locally, install [Vigilion](https://github.com/bitzesty/vigilion-scanner) and set the `VIGILION_ACCESS_KEY_ID` and `VIGILION_SECRET_ACCESS_KEY` and `DISABLE_VIRUS_SCANNER` to `false` in the `.env` file.

### Running the tests

    $ bundle exec rspec

## Documentation

We have documentation within the doc folder. Architecture decisions and technical diagrams are stored within doc/architecture/decisions and doc/architecture/diagrams respectively.

We use [adr-tools](https://github.com/npryce/adr-tools) to manage our architecture decisions.

Diagrams are written using [PlantUML](https://plantuml.com/) and C4 notation.

If you're using an IDE or editor with a PlantUML plugin, there's often a setting to specify the format (png) and output directory. For example, in VS Code with the PlantUML extension, you can add this to your settings.json:

```json
"plantuml.outputDirectory": "."
```

## Deploying

Continuous Deployment is setup and the application will automatically deploy after passing CI on the target branch (main, staging). Production deployment is a manually triggered action (production branch). For more details see the Github Actions.

CF based GOV.UK PaaS is used for hosting [https://cloud.service.gov.uk](https://www.cloud.service.gov.uk/).

## License

QAE is Copyright © 2014 Crown Copyright & Bit Zesty. It is free
software, and may be redistributed under the terms specified in the
[LICENSE] file.

[license]: https://github.com/bitzesty/qae/blob/master/LICENSE

## Helpful links
- [GDS service standards](https://www.gov.uk/service-manual/service-standard)
- [GDS design principles](https://www.gov.uk/design-principles)

## About Bit Zesty

![Bit Zesty](https://bitzesty.com/wp-content/uploads/2017/01/logo_dark.png)

QAE is maintained by [Bit Zesty Limited](https://bitzesty.com/).

