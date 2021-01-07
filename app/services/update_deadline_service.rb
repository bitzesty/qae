class UpdateDeadlineService
  attr_reader :deadline, :params

  def initialize(deadline, params)
    @deadline = deadline
    @params = params
  end

  def perform
    if deadline.update(params)
      trigger_states_transition
    end
  end

  private

  def trigger_states_transition
    now = DateTime.now
    trigger_at = deadline.trigger_at

    if deadline.submission_end? && trigger_at.present? && now >= trigger_at
      ::SubmissionDeadlineStatesTransitionWorker.perform_async
    end

    if deadline.audit_certificates? && trigger_at.present? && now >= trigger_at
      ::DisqualifiedDeadlineStatesTransitionWorker.perform_async
    end
  end
end
