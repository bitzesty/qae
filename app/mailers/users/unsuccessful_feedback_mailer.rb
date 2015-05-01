class Users::UnsuccessfulFeedbackMailer < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    @company_name = @form_answer.company_or_nominee_name

    subject = "Queen's Award for Enterprise: Application Feedback"
    mail to: @user.email, subject: subject
  end

  def ep_notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    @nominee_name = @form_answer.nominee_full_name

    subject = "Queen's Award for Enterprise Promotion: Nomination Feedback"
    mail to: @user.email, subject: subject
  end
end
