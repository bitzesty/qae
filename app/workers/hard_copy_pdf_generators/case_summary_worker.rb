class HardCopyPdfGenerators::CaseSummaryWorker
  include Sidekiq::Worker

  def perform(form_answer_id)
    form_answer = FormAnswer.find(form_answer_id)
    form_answer.generate_case_summary_hard_copy_pdf!
  end
end
