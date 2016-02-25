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
    trigger_at = deadline.trigger_at

    if deadline.submission_end? && trigger_at.present?
      if now >= trigger_at
        ::SubmissionDeadlineStatesTransitionWorker.perform_async("#{deadline.id}_#{now}")
      end

      # TODO: check this after migration to sidekiq
      ::SubmissionDeadlineApplicationPdfGenerationWorker.set(
        wait_until: trigger_at
      ).perform_later
    end
  end
end
