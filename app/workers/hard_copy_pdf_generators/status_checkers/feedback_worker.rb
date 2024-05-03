class HardCopyPdfGenerators::StatusCheckers::FeedbackWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    AwardYear.current.check_hard_copy_pdf_generation_status!("feedback")
  end
end
