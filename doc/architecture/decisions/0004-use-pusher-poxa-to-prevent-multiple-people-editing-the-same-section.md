# 4. Use Poxa to Prevent Multiple People Editing the Same Section

Date: 2016-06-01

## Status

Accepted

## Context

There were cases where multiple users were editing the application form at the same time. While we want to encourage collaboration, we do not want users to potentially overwrite their data.

## Decision

Use the open-source WebSocket server Poxa (Pusher compatible), to enable collaborators to work on different sections of the application form in real-time, while preventing edits to the same part of the form.

## Consequences

We will need to self-host Poxa. Upcoming features in the Rails framework (Action Cable) will enable WebSocket communication, and we could eventually remove this external dependency.