class HardCopyPdfGenerators::Aggregated::FeedbacksWorker < HardCopyPdfGenerators::BaseWorker

  def perform
    year = AwardYear.current

    if year.aggregated_feedback_generation_can_be_started?
      # Set status of generation process
      year.update_column(:aggregated_feedback_hard_copy_state, "started")

      HardCopyGenerators::AggregatedFeedbackGenerator.run(year)

      # Run check generation results scripe 1 hour later
      HardCopyPdfGenerators::StatusCheckers::AggregatedFeedbackWorker.perform_at(1.hour.from_now)
    end
  end
end
