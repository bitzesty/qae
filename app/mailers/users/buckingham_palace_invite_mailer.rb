class Users::BuckinghamPalaceInviteMailer < AccountMailer
  def invite(invite_id)
    invite = PalaceInvite.find(invite_id)
    @token = invite.token
    @form_answer = invite.form_answer.decorate
    @user = @form_answer.user.decorate

    @name = "#{@user.title} #{@user.last_name}"

    subject = "An invitation to HM The Queen's Reception at Buckingham Palace"
    mail to: invite.email, subject: subject
  end
end
