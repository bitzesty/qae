require File.expand_path(File.dirname(__FILE__) + "/environment")

set :job_template, "env PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH /bin/bash -l -c ':job'"
set :output, File.expand_path("#{File.dirname __FILE__}/../log/cron_log.log")

# All scheduled tasks need to run with a advisory_lock
# To prevent two processes running them concurrently
# User.with_advisory_lock('name', 0) { block }

# Do not run jobs with the same offset

every :day, at: "12:30am" do
  runner "CronJobRun.run('deadlines', 0, 5) { FormAnswerStateMachine.trigger_deadlines }"
end

every :hour do
  runner "CronJobRun.run('email_notification', 0, 5) { Notifiers::EmailNotificationService.run }"
end
