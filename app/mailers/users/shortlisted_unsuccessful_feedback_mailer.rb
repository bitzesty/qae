class Users::ShortlistedUnsuccessfulFeedbackMailer < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    # since it's only used for business forms
    # it will be always a company name
    @company_name = @form_answer.company_or_nominee_name

    subject = "Queen's Award for Enterprise: Application Feedback"
    mail to: @user.email, subject: subject
  end
end
