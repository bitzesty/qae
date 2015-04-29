class Users::BuckinghamPalaceInviteMailer < ApplicationMailer
  def invite(invite_id, name)
    invite = PalaceInvite.find(invite_id)
    @token = invite.token
    @form_answer = invite.form_answer.decorate
    @name = name
    @deadline = Settings.current.deadlines.where(kind: "buckingham_palace_attendees_details").first
    @deadline = @deadline.trigger_at.strftime("%d/%m/%Y")

    subject = "Queen's Awards for Enterprise: Congratulations, you've won!"
    mail to: invite.email, subject: subject
  end
end
