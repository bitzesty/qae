require File.expand_path(File.dirname(__FILE__) + "/environment")

set :job_template, "env PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH /bin/bash -l -c ':job'"
set :output, File.expand_path("#{File.dirname __FILE__}/../log/cron_log.log")

# All scheduled tasks need to run with a advisory_lock
# To prevent two processes running them concurrently
# User.with_advisory_lock('name', 0) { block }

# Do not run jobs with the same offset

every 10.minutes do
  runner "CronJob.run('deadlines') { FormAnswerStateMachine.trigger_deadlines }"
end

every :hour do
  runner "CronJob.run('email_notification') { Notifiers::EmailNotificationService.run }"
end

case @environment
when 'production'
  every :sunday, at: "12pm" do
    runner "CronJob.run('performance') { PerformancePlatformService.run }"
  end
end
