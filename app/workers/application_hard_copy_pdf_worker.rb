class ApplicationHardCopyPdfWorker
  include Sidekiq::Worker

  def perform(form_answer_id)
    form_answer = FormAnswer.find(form_answer_id)
    form_answer.generate_pdf_version!
  end
end
