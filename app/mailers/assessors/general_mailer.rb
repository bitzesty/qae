class Assessors::GeneralMailer < ApplicationMailer
  def led_application_withdrawn(form_answer_id, assessor_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @assessor = Assessor.find(assessor_id)
    @subject = "Application Ref: #{@form_answer.urn} Withdrawn/Ineligible"
    mail to: @assessor.email, subject: @subject
  end

  def audit_certificate_uploaded(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @assessor = @form_answer.assessors.primary
    @subject = "Application Ref: #{@form_answer.urn} Verification of Commercial Figures submitted"
    mail to: @assessor.email, subject: @subject
  end
end
