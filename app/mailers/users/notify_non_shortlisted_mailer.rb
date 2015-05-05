class Users::NotifyNonShortlistedMailer < AccountMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = form_answer.user.decorate
    @subject = "Queen's Awards for Enterprise: Thank you for applying"

    mail to: @user.email, subject: @subject
  end

  def ep_notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    @subject = "Queen's Awards for Enterprise Promotion: Thank you for your nomination"

    mail to: @user.email, subject: @subject
  end
end
