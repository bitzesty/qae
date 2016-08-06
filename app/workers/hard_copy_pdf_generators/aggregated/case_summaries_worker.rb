class HardCopyPdfGenerators::Aggregated::CaseSummariesWorker < HardCopyPdfGenerators::BaseWorker

  def perform
    year = AwardYear.current

    if year.aggregated_case_summary_generation_can_be_started?
      # Set status of generation process
      year.update_column(:aggregated_case_summary_hard_copy_state, 'started')

      HardCopyGenerators::AggregatedCaseSummaryGenerator.new.run
    end
  end
end
