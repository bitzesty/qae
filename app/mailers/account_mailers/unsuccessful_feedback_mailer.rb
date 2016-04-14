class AccountMailers::UnsuccessfulFeedbackMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @year = AwardYear.closed.year
    @name = "#{@user.title} #{@user.last_name}"

    subject = "Important information about your Queen's Award entry"
    mail to: collaborator.email, subject: subject
  end

  def ep_notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @nominee_name = @form_answer.nominee_full_name
    @year = AwardYear.closed.year

    subject = "Important information about your Queen's Award nomination"
    mail to: collaborator.email, subject: subject
  end
end
