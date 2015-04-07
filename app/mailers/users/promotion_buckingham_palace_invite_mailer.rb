class Users::PromotionBuckinghamPalaceInviteMailer < ApplicationMailer
  def notify(invite_id)
    invite = PalaceInvite.find(invite_id)
    award = invite.form_answer.decorate.award_type
    @token = invite.token

    subject = "[Queen's Awards] #{award} request to fill in attendee details"
    mail to: invite.email, subject: subject
  end
end
