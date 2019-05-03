class Users::AuditCertificateMailer < ApplicationMailer
  def notify(form_answer_id, user_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @recipient = User.find(user_id).decorate

    subject = "Queen's Awards for Enterprise: Verification of Commercial Figures submitted"
    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @recipient.email, subject: subject
  end
end
