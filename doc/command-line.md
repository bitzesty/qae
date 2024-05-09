# Opening a Rails console

Ensure you've [installed the CloudFoundry CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) tool and have access to your GOV UK PAAS credentials.

Example for production:

    cf ssh qae-production
    /tmp/lifecycle/launcher "app" "$SHELL" ""
    rails console