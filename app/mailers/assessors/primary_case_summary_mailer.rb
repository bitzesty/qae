class Assessors::PrimaryCaseSummaryMailer < ApplicationMailer
  def notify(assessor_id, form_answer_id)
    @recipient = Assessor.find(assessor_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @award_title = @form_answer.decorate.award_application_title

    @subject = "TODO: copy"
    mail to: @recipient.email, subject: @subject
  end
end
