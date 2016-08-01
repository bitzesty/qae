class HardCopyPdfGenerators::Aggregated::CaseSummariesWorker
  def perform
    # TODO

    HardCopyPdfGenerators::StatusCheckers::AggregatedCaseSummariesWorker.perform_async
  end
end
