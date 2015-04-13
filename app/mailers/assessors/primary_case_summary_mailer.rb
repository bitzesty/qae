class Assessors::PrimaryCaseSummaryMailer < ApplicationMailer
  def notify(assessor_id, form_answer_id, changes_author_id)
    @recipient = Assessor.find(assessor_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @award_title = @form_answer.decorate.award_application_title
    @author = Assessor.find(changes_author_id)
    @subject = "Application Ref: #{@form_answer.urn} Case Summary submitted"
    mail to: @recipient.email, subject: @subject
  end
end
