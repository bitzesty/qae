class UpdateDeadlineService
  attr_reader :deadline, :params

  def initialize(deadline, params)
    @deadline = deadline
    @params = params
  end

  def perform
    return unless deadline.update(params)

    trigger_states_transition
  end

  private

  def trigger_states_transition
    now = DateTime.now
    trigger_at = deadline.trigger_at

    ::SubmissionDeadlineStatesTransitionWorker.perform_async if deadline.submission_end? && trigger_at.present? && now >= trigger_at

    return unless deadline.audit_certificates? && trigger_at.present? && now >= trigger_at

    ::DisqualifiedDeadlineStatesTransitionWorker.perform_async
  end
end
