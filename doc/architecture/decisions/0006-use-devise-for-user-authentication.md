# 6. Use Devise for User Authentication

Date: 2014-11-24

## Status

Accepted

## Context

We need a way for users to save their application forms in progress and to check the status of their applications. While companies must be UK-based, the users of the application may be outside the UK (making it hard to use GOV.UK Verify).

## Decision

We will use the open-source Ruby on Rails library, Devise, for user authentication. This library is also used in the voluntary service award application, and we can reuse their secure default configuration.

## Consequences

We will need to manage and maintain the authentication library to ensure it remains secure. Devise is widely used and a de facto standard within the Ruby on Rails community, so it should be easy for other team members to use.