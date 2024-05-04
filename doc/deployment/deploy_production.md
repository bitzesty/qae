# Production Environment Deployment

```mermaid
flowchart TB
    subgraph production["Production Environment"]
        start([Start])
        pr([Raise a new pull request from staging to production])
        tests([Unit tests, integration tests, security and linting are run in Github Actions])
        review([Code review by at least one contributor])
        approve([Approve and Merge])
        deploy([Code is manually deployed to production via Github Actions])
        stop([Stop])

        start --> pr
        pr --> tests
        tests --> review
        review --> approve
        approve --> deploy
        deploy --> stop
    end
