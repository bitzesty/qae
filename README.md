Queen's Awards for Enterprise
---------------------------

## Setup Notes:

1) If you got:

```
ActiveRecord::StatementInvalid: PG::UndefinedFile: ERROR:  could not open extension control file "/usr/share/postgresql/9.3/extension/hstore.control": No such file or directory
: CREATE EXTENSION IF NOT EXISTS "hstore"

```

This means, that hstore postgresql extension needs to be installed:
```
sudo apt-get install postgresql-contrib
```


