# 3. Use PostgreSQL as the database

Date: 2014-11-17

## Status

Accepted

## Context

The service will store both relational and potentially non-relational data. In order to simplify the architecture, we will use a single database to store all data.

## Decision

We will use PostgreSQL as the database for the service. We will use the JSONB data type to store non-relational data.

## Consequences

Indexes on JSONB columns are slower than indexes on relational columns. However maintaining two seperate datastores would add complexity to the architecture.

