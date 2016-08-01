class HardCopyPdfGenerators::Aggregated::FeedbacksWorker
  def perform
    # TODO

    HardCopyPdfGenerators::StatusCheckers::AggregatedFeedbacksWorker.perform_async
  end
end
