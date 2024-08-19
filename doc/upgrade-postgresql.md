# Upgrading major versions of Postgres

https://docs.cloud.service.gov.uk/deploying_services/postgresql/#upgrading-major-versions-of-postgres

**Troubleshooting**

- If you get an error similar to the one below, you need to upgrade the RDS instance class to a supported one. You can do this via the AWS console.

```
Job (fb9b18c1-3bb6-49a2-9794-ee57eca56127) failed: update could not be completed: Service broker error: InvalidParameterCombination: RDS does not support creating a DB instance with the following combination: DBInstanceClass=db.t2.micro, Engine=postgres, EngineVersion=13.8, LicenseModel=postgresql-license. For supported combinations of instance class and database engine version, see the documentation.
```
try to update the current minor version to the latest with the following command:

```
cf update-service {SERVICE_NAME} -c '{"update_minor_version_to_latest": true}'
```

