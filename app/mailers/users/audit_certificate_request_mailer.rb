class Users::AuditCertificateRequestMailer < ApplicationMailer
  def notify(form_answer_id, user_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @recipient = User.find(user_id).decorate
    @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    @trigger_at = @deadline.trigger_at
    @deadline = @trigger_at.strftime("%d/%m/%Y")

    @deadline_time = @trigger_at.strftime("%H:%M")
    @deadline_time = "midnight" if midnight?
    @deadline_time = "midday" if midday?

    @subject = "King's Awards for Enterprise: Reminder to provide verification of commercial figures - Application ref #{@form_answer.urn}"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @recipient.email, subject: subject_with_env_prefix(@subject)
  end

  private

  def midday?
    @trigger_at == @trigger_at.midday
  end

  def midnight?
    @trigger_at == @trigger_at.midnight
  end
end
