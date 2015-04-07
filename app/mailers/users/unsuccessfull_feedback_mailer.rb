class Users::UnsuccessfullFeedbackMailer < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate

    subject = "[Queen's Awards] #{@form_answer.award_title} application was unsuccessfull"
    mail to: @user.email, subject: subject
  end
end
