# 9. Use `sidekiq-throttled` to Rate-limit Email Delivery

Date: 2024-05-07

## Status

Accepted

## Context

We need a way to rate limit outgoing emails as we experience errors related to exceeding rate limits placed by GOV.UK Notify service (used by application to deliver emails).

## Decision

We will use the open-source Ruby on Rails library, `sidekiq-throttled`. Currently, this library seems to be the only one being maintained, however it can be only used to rate-limit Sidekiq jobs. The other solutions are either not maintained anymore or didn't offer the functionality we needed.

## Consequences

Since the library `sidekiq-throttled` can only be used to rate-limit jobs emitted by Sidekiq. The email delivery is however run by built-in Ruby on Rails solution called ActiveJob. We will have to extend Ruby on Rails functionality to use Sidekiq worker for email delivery, preferably in a way that would not affect the current API for sending email from application.
