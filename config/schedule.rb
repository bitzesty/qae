every 5.minutes do
  runner "Notifiers::EmailNotificationService.run"
end

every 5.minutes do
  runner "FormAnswerStateMachine.trigger_deadlines"
end

every :sunday, at: "12pm" do
  runner "PerformancePlatformService.run"
end
