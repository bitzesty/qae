class HardCopyPdfGenerators::StatusCheckers::FormDataWorker < HardCopyPdfGenerators::BaseWorker
  def perform
    AwardYear.current.check_hard_copy_pdf_generation_status!("form_data")
  end
end
