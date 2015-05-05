class Users::PromotionLettersOfSupportReminderMailer < AccountMailer
  def notify(form_answer_id)
    trigger_at = Settings.current_submission_deadline.trigger_at
    @days_before_submission = (trigger_at.to_date - Date.current).to_i
    @deadline = trigger_at.strftime("%d/%m/%Y")
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @nominee_name = @form_answer.nominee_full_name
    @user = @form_answer.user

    subject = "Queen's Award for Enterprise Promotion: Continue your nomination"

    mail to: @user.email, subject: subject
  end
end
