# Updating enviroment variables on GOV PaaS

Log into CF & select environment

To list env vars in a particular environment e.g. staging

    cf env qae-staging

To set an env var use:

    cf set-env qae-staging ENV value


You then need to restage (or redeploy):

    cf restage qae-staging