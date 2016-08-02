module Scheduled
  class SubmissionDeadlineWorker < BaseWorker
    def perform
      ::FormAnswerStateMachine.trigger_deadlines
    end
  end
end
