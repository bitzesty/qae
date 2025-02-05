# ![Logo](https://raw.githubusercontent.com/bitzesty/qae/master/public/logo.jpg) King's Awards for Enterprise

"QAE" is the application which powers the application process for The King's Awards for Enterprise.

## Development

### Prerequisites

- Ruby 3.2.4
  - `gem install bundler -v 2.5.6`
- Node.js LTS
- Rails 7.0
- Postgresql 9.5+ with `hstore` extension
- Redis 4+
- Docker

### Running the application

There are environment variables that you may want to modify in the `.env` file.

```
cp .env.example .env
```

This ensures the necessary environment variables set before running the Docker commands.

#### Running with docker

1. Build the containers:

   ```
   docker-compose build
   ```

2. In a new terminal, set up and migrate the database:

   ```
   docker-compose run --rm web bundle exec rails db:prepare
   ```

3. Run the containers:

   ```
   docker-compose up
   ```

Your application should now be running at http://localhost:3000

##### Running Rails with the production config

Locally the docker image will run Rails in development, if you need to run as production
then specify the production file `docker-compose -f docker-compose.prod.yml`

You will need to generate a local ssl certificate for nginx.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./certs/privkey.pem -out ./certs/fullchain.pem

Your application should now be running at https://localhost/

### Installing Poxa

If you need to test collaborators editing the application at the same time, install [poxa](https://github.com/bitzesty/poxa).

### Installing Malware Scanning

Files are uploaded to S3 and then scanned with ClamAV via the DBT scanner service.

If you need to test malware scanning locally, run the [DBT scanner](https://github.com/uktrade/dit-clamav-rest) via docker-compose.

You will also need to set the following environment variables in the `.env` file:

```
VIRUS_SCANNER_URL=http://localhost:80
VIRUS_SCANNER_USERNAME=app1
VIRUS_SCANNER_PASSWORD=letmein
```


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

test
