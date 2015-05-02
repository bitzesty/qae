set :output, File.expand_path("#{File.dirname __FILE__}/../log/cron_log.log")

# All scheduled tasks need to run with a advisory_lock
# To prevent two processes running them concurrently
# User.with_advisory_lock('name', 0) { block }

# Do not run jobs with the same offset

every 7.minutes do
  runner "User.with_advisory_lock('email_notification', 0) { Notifiers::EmailNotificationService.run }"
end

every 5.minutes do
  runner "User.with_advisory_lock('deadlines', 0) { FormAnswerStateMachine.trigger_deadlines }"
end
