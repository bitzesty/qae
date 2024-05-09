# 7. Use GOV.UK Notify for Email Sending

Date: 2019-05-03

## Status

Accepted

## Context

We are currently paying for email sending services, and the UK Government has developed GOV.UK Notify to enable services to send emails, SMS, and letters. Additionally, the sending domain would be from the UK Government, which would improve email deliverability.

## Decision

We will migrate the service to use GOV.UK Notify. This will require us to implement a workaround to maintain our email templates within the application codebase. All emails will use the same template, which will act as an empty template, as Notify does not currently support providing the full contents of a message via the API directly.

## Consequences

We have a single point of failure; should someone edit or delete the main template, email sending will be disrupted. It would be quick to recreate the template (as it is empty), and we will provide training and guidance to ensure the team knows not to edit the template.