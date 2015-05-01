class Users::PromotionBuckinghamPalaceInviteMailer < ApplicationMailer
  def notify(invite_id)
    invite = PalaceInvite.find(invite_id)
    @form_answer = invite.form_answer.decorate
    @token = invite.token
    @name = @form_answer.nominee_full_name
    @user = @form_answer.user.decoarate
    @deadline = Settings.current.deadlines.where(kind: "buckingham_palace_attendees_details").first
    @deadline = @deadline.trigger_at.strftime("%d/%m/%Y")

    subject = "Queen's Award for Enterprise Promotion: Congratulations, you've won!"
    mail to: invite.email, subject: subject
  end
end
