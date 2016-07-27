module Scheduled
  class AuditDeadlineWorker < BaseWorker
    def perform
      ::FormAnswerStateMachine.trigger_audit_deadlines
    end
  end
end
