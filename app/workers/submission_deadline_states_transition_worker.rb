class SubmissionDeadlineStatesTransitionWorker
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(_sqs_msg)
    FormAnswerStateMachine.trigger_deadlines
  end
end
