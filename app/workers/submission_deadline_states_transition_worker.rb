class SubmissionDeadlineStatesTransitionWorker
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true

  def perform(sqs_msg)
    FormAsnwerStateMachine.trigger_deadlines
  end
end
