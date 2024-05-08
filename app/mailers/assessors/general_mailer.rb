class Assessors::GeneralMailer < ApplicationMailer
  def led_application_withdrawn(form_answer_id, assessor_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @assessor = Assessor.find(assessor_id)
    @subject = "Application Ref: #{@form_answer.urn} Withdrawn/Ineligible"
    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @assessor.email, subject: subject_with_env_prefix(@subject)
  end

  def audit_certificate_uploaded(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @assessor = @form_answer.assessors.primary
    @subject = "Application Ref: #{@form_answer.urn} External Accountant's Report submitted"
    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @assessor.email, subject: subject_with_env_prefix(@subject)
  end

  def vat_returns_submitted(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @assessor = @form_answer.assessors.primary
    @subject = "Application Ref: #{@form_answer.urn} Latest financial information has been submitted"
    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @assessor.email, subject: subject_with_env_prefix(@subject)
  end
end
