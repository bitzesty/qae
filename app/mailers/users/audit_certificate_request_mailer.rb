class Users::AuditCertificateRequestMailer < ApplicationMailer
  def notify(user_id, form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @form_owner = @form_answer.user.decorate
    @recipient = User.find(user_id).decorate
    @award_title = @form_answer.decorate.award_application_title

    @subject = "[Queen's Awards] #{@award_title} request to complete an audit certificate!"
    mail to: @recipient.email, subject: @subject
  end
end
