# Development Environment Deployment

```mermaid
flowchart TB
    subgraph staging["Staging Environment"]
        start([Start])
        branch([Branch off main])
        code([Write feature code])
        pr([Open a new pull request back into main])
        tests([Unit tests, integration tests, security and linting are run in Github Actions])
        review([Code review by at least one contributor])
        approve([Approve and Merge])
        deploy([Code is automatically deployed to staging via Github Actions])
        stop([Stop])

        start --> branch
        branch --> code
        code --> pr
        pr --> tests
        tests --> review
        review --> approve
        approve --> deploy
        deploy --> stop
    end
