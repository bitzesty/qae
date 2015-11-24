class Users::NotifyNonShortlistedMailer < AccountMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = form_answer.user.decorate
    @current_year = @form_answer.award_year.year
    @subject = "Queen's Awards for Enterprise: Thank you for applying"

    mail to: @user.email, subject: @subject
  end

  # ep_notify is disabled for now
  def ep_notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    @current_year = @form_answer.award_year.year
    @subject = "Queen's Awards for Enterprise Promotion: Thank you for your nomination"

    mail to: @user.email, subject: @subject
  end
end
