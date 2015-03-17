class Users::SubmissionMailer < ApplicationMailer
  def success(user_id, form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @form_owner = @form_answer.user.decorate
    @recipient = User.find(user_id).decorate
    @subject = "[Queen's Awards for Enterprise] submission successfully created!"

    mail to: @recipient.email, subject: @subject
  end
end
