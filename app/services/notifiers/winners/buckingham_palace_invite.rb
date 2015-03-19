class Notifiers::Winners::BuckinghamPalaceInvite
  include Shoryuken::Worker

  shoryuken_options queue: "default", auto_delete: true

  def perform(sqs_msg, email)
    invite = PalaceInvite.where(email: email).first_or_create
    Users::BuckinghamPalaceInviteMailer.invite(invite.id).deliver_later!
  end
end
