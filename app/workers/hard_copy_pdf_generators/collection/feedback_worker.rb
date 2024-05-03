class HardCopyPdfGenerators::Collection::FeedbackWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    year = AwardYear.current

    return unless year.feedback_generation_can_be_started?

    # Set status of generation process
    year.update_column(:feedback_hard_copies_state, "started")

    # Schedule individual PDF generation worker per each FormAnswer entry
    AwardYear.current.hard_copy_feedback_scope.find_each do |form_answer|
      HardCopyPdfGenerators::FeedbackWorker.perform_async(form_answer.id)
    end

    # Run check generation results scripe 6 hours later
    HardCopyPdfGenerators::StatusCheckers::FeedbackWorker.perform_at(6.hours.from_now)
  end
end
