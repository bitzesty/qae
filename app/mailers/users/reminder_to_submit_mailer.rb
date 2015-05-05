class Users::ReminderToSubmitMailer < AccountMailer
  def notify(form_answer_id)
    trigger_at = Settings.current_submission_deadline.trigger_at
    @days_before_submission = (trigger_at.to_date - Date.current).to_i
    @deadline = trigger_at.strftime("%d/%m/%Y")
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user

    subject = "Queen's Awards for Enterprise: Reminder to submit"

    mail to: @user.email, subject: subject
  end
end
