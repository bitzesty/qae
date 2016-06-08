class SubmissionDeadlineStatesTransitionWorker
  include Sidekiq::Worker

  def perform
    FormAnswerStateMachine.trigger_deadlines
  end
end
