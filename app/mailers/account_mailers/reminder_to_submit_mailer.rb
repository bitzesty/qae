class AccountMailers::ReminderToSubmitMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    trigger_at = Settings.current_submission_deadline.trigger_at
    @days_before_submission = (trigger_at.to_date - Date.current).to_i
    @deadline = trigger_at.strftime("%H.%M hrs on %d %B %Y")
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user
    collaborator = User.find(collaborator_id)

    subject = "Queen's Awards for Enterprise: Reminder to submit"

    mail to: collaborator.email, subject: subject
  end
end
