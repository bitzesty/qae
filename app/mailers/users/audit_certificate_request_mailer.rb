class Users::AuditCertificateRequestMailer < ApplicationMailer
  def notify(user_id, form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @recipient = User.find(user_id).decorate
    @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    @deadline = @deadline.trigger_at.strftime("%d/%m/%Y")

    @subject = "Queen's Awards for Enterprise: Reminder to submit your Audit Certificate"
    mail to: @recipient.email, subject: @subject
  end
end
