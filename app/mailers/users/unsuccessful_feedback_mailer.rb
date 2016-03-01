class Users::UnsuccessfulFeedbackMailer < AccountMailer
  def notify(form_answer_id, user_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = User.find(user_id).decorate
    @year = AwardYear.closed.year
    @name = "#{@user.title} #{@user.last_name}"

    subject = "Important information about your Queen's Award entry"
    mail to: @user.email, subject: subject
  end

  def ep_notify(form_answer_id, user_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = User.find(user_id).decorate
    @nominee_name = @form_answer.nominee_full_name
    @year = AwardYear.closed.year

    subject = "Important information about your Queen's Award nomination"
    mail to: @user.email, subject: subject
  end
end
