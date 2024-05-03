class AccountMailers::PromotionLettersOfSupportReminderMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    trigger_at = Settings.current_submission_deadline.trigger_at
    @days_before_submission = (trigger_at.to_date - Date.current).to_i
    @deadline = trigger_at.strftime("%d/%m/%Y")
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @nominee_name = @form_answer.nominee_full_name
    @user = @form_answer.user
    collaborator = User.find(collaborator_id)

    subject = "King's Award for Enterprise Promotion: Continue your nomination"

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: collaborator.email,
                                                                              subject: subject_with_env_prefix(subject)
  end
end
