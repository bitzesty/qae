class SubmissionDeadlineApplicationPdfGenerationWorker
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true

  def perform(_sqs_msg)
    AwardYear.current.form_answers.submitted.find_each do |form_answer|
      ApplicationHardCopyPdfWorker.perform_async(form_answer.id)
    end
  end
end
