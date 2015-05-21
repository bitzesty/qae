class SubmissionDeadlineStatesTransitionWorker
  include Shoryuken::Worker

  shoryuken_options queue: "#{ENV['AWS_SQS_QUEUE_ADVANCED_PREFIX']}#{Rails.env}_default", auto_delete: true

  def perform(_sqs_msg)
    FormAsnwerStateMachine.trigger_deadlines
  end
end
