class HardCopyPdfGenerators::FormDataWorker < HardCopyPdfGenerators::BaseWorker
  def perform(form_answer_id, generate_from_latest_doc=false)
    form_answer = FormAnswer.find(form_answer_id)

    if generate_from_latest_doc
      form_answer.generate_pdf_version_from_latest_doc!
    else
      form_answer.generate_pdf_version!
    end
  end
end
