class Users::SubmissionMailer < ActionMailer::Base
  default from: "support@qae.co.uk"

  def success(user_id, form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @form_owner = @form_answer.user.decorate
    @recipient = User.find(user_id).decorate
    @urn = @form_answer.urn
    @subject = "[Queen's Awards for Enterprise] submission successfully created!"

    mail to: @recipient.email, subject: @subject
  end
end
