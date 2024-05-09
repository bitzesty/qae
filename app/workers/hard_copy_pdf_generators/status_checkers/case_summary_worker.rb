class HardCopyPdfGenerators::StatusCheckers::CaseSummaryWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    AwardYear.current.check_hard_copy_pdf_generation_status!("case_summary")
  end
end
