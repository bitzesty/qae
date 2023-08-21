class Users::WinnersPressRelease < AccountMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate

    @deadline = Settings.current.deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
    @deadline = @deadline.trigger_at.strftime("%d/%m/%Y")

    @token = @form_answer.press_summary.token
    @subject = "[Queen's Awards for Enterprise] Press Comment"

    mail to: @user.email, subject: @subject
  end
end
