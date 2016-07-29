class DisqualifiedDeadlineStatesTransitionWorker
  include Sidekiq::Worker

  def perform
    FormAnswerStateMachine.trigger_audit_deadlines
  end
end
