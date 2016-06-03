class AccountMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(invite_id, collaborator_id)
    invite = PalaceInvite.find(invite_id)
    collaborator = User.find(collaborator_id)

    @token = invite.token
    @form_answer = invite.form_answer.decorate
    @user = @form_answer.user.decorate

    @reception_date = AwardYear.buckingham_palace_reception_date
    @reception_date = @reception_date.try(:strftime, "%A %d %B at %-l:%M%P")

    @palace_attendees_due = AwardYear.buckingham_palace_reception_attendee_information_due_by
    @palace_attendees_due = @palace_attendees_due.try(:strftime, "%A%e %B")

    @name = "#{@user.title} #{@user.last_name}"

    subject = "An invitation to HM The Queen's Reception at Buckingham Palace"
    mail to: collaborator.email, subject: subject
  end
end
