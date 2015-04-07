class Assessors::GeneralMailer < ApplicationMailer
  def led_application_withdrawn(form_answer_id, assessor_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @assessor = Assessor.find(assessor_id)
    @subject = "TODO: copy"
    mail to: @assessor.email, subject: @subject
  end
end
