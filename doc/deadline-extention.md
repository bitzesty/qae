# Extending the deadline and sending reminders

Test this process in staging before running in production.

1. Set the new date in the admin console for closing of the deadline.
2. Update the copy of the reminder emails in notify.
3. Clear the redis cache, by [opening the rails console](./command-line.md) and then running:

```powershell
rails c
Rails.cache.clear
```

1. Trigger a deployment to restart the servers.
2. Test the reminder email on the command line with a test user.