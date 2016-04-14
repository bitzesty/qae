class AccountMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(invite_id, collaborator_id)
    invite = PalaceInvite.find(invite_id)
    collaborator = User.find(collaborator_id)

    @token = invite.token
    @form_answer = invite.form_answer.decorate
    @user = @form_answer.user.decorate

    @invite_date = AwardYear.buckingham_palace_reception_date
    @invite_date = @invite_date.try(:strftime, "%A #{@invite_date.day.ordinalize} %B")

    @name = "#{@user.title} #{@user.last_name}"

    subject = "An invitation to HM The Queen's Reception at Buckingham Palace"
    mail to: collaborator.email, subject: subject
  end
end
