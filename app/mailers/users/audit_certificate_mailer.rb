class Users::AuditCertificateMailer < ApplicationMailer
  def notify(form_answer_id, user_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @recipient = User.find(user_id).decorate

    subject = "King's Awards for Enterprise: Verification of Commercial Figures submitted - Application ref #{@form_answer.urn}"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @recipient.email, subject: subject_with_env_prefix(subject)
  end
end
