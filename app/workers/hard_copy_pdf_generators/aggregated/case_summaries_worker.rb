class HardCopyPdfGenerators::Aggregated::CaseSummariesWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    year = AwardYear.current

    return unless year.aggregated_case_summary_generation_can_be_started?

    # Set status of generation process
    year.update_column(:aggregated_case_summary_hard_copy_state, "started")

    HardCopyGenerators::AggregatedCaseSummaryGenerator.run(year)

    # Run check generation results scripe 1 hour later
    HardCopyPdfGenerators::StatusCheckers::AggregatedCaseSummaryWorker.perform_at(1.hour.from_now)
  end
end
