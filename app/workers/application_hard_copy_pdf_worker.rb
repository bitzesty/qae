class ApplicationHardCopyPdfWorker
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true

  def perform(sqs_msg, form_answer_id)
    form_answer = FormAnswer.find(form_answer_id)
    form_answer.generate_pdf_version!
  end
end
