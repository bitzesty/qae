class Notifiers::Submission::SuccessNotifier < Notifiers::AccountNotifier

  def initialize(form_answer)
    @form_answer = form_answer
    @account = form_answer.account
  end

  def run
    recipients.each do |recipient|
      Users::SubmissionMailer.delay.success(recipient.id, form_answer.id)
    end
  end
end
