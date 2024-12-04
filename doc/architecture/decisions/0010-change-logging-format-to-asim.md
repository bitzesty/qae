# 10. Change logging format to ASIM

Date: 2024-08-13

## Status

Accepted

## Context

While migrating the application off the GOV PaaS, we're standardising the logging format to ASIM, which is used by the department's SIEM.

## Decision

Switch the logging format to ASIM.

## Consequences

We cant analyse the logs within appsignal but, we should still have a way to view the logs on the new platform.
We need to implement a new log formatter, and we will use the Django implementation as a reference.
