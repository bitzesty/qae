class UpdateDeadlineService
  attr_reader :deadline, :params

  def initialize(deadline, params)
    @deadline = deadline
    @params = params
  end

  def perform
    if deadline.update_attributes(params)
      trigger_states_transition
    end
  end

  private

  def trigger_states_transition
    now = DateTime.now
    if deadline.submission_end? && now >= deadline.trigger_at
      ::SubmissionDeadlineStatesTransitionWorker.perform_async("#{deadline.id}-#{now}")
    end
  end
end
