class HardCopyPdfGenerators::StatusCheckers::AggregatedFeedbackWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    AwardYear.current.check_aggregated_hard_copy_pdf_generation_status!("feedback")
  end
end
