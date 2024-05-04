# Staging Environment Deployment

```mermaid
flowchart TB
    subgraph staging["Staging Environment"]
        start([Start])
        pr([Raise a new pull request from main to staging])
        tests([Unit tests, integration tests, security and linting are run in Github Actions])
        review([Code review by at least one contributor])
        approve([Approve and Merge])
        deploy([Code is automatically deployed to staging via Github Actions])
        stop([Stop])

        start --> pr
        pr --> tests
        tests --> review
        review --> approve
        approve --> deploy
        deploy --> stop
    end
