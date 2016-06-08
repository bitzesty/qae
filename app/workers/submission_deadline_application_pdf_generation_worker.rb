class SubmissionDeadlineApplicationPdfGenerationWorker
  include Sidekiq::Worker

  def perform
    AwardYear.current.form_answers.submitted.find_each do |form_answer|
      ApplicationHardCopyPdfWorker.perform_async(form_answer.id)
    end
  end
end
