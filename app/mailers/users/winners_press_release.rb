class Users::WinnersPressRelease < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate

    email = if @form_answer.promotion?
      @form_answer.document["nominee_email"]
    else
      @user.email
    end

    @token = @form_answer.press_summary.token
    @subject = "[Queen's Awards for Enterprise] Press Comment"

    mail to: email, subject: @subject
  end
end
