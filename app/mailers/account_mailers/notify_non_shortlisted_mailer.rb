class AccountMailers::NotifyNonShortlistedMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @current_year = @form_answer.award_year.year
    @subject = "King's Awards for Enterprise: Thank you for applying - Application ref #{@form_answer.urn}"

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: collaborator.email,
                                                                              subject: subject_with_env_prefix(@subject)
  end

  # ep_notify is disabled for now
  def ep_notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @current_year = @form_answer.award_year.year
    @subject = "King's Awards for Enterprise Promotion: Thank you for your nomination"

    send_mail_if_not_bounces ENV.fetch("GOV_UK_NOTIFY_API_TEMPLATE_ID", nil), to: collaborator.email,
                                                                              subject: subject_with_env_prefix(@subject)
  end
end
