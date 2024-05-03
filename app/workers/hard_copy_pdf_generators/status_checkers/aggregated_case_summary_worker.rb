class HardCopyPdfGenerators::StatusCheckers::AggregatedCaseSummaryWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    AwardYear.current.check_aggregated_hard_copy_pdf_generation_status!("case_summary")
  end
end
