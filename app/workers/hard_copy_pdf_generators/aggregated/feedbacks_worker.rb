class HardCopyPdfGenerators::Aggregated::FeedbacksWorker
  def perform
    year = AwardYear.current

    if year.aggregated_feedback_generation_can_be_started?
      # Set status of generation process
      year.update_column(:aggregated_feedback_hard_copy_state, 'started')

      HardCopyGenerators::AggregatedFeedbackGenerator.new.run
    end
  end
end
