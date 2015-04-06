class Notifiers::Winners::BuckinghamPalaceInvite
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true

  def perform(sqs_msg, email)
    # creating it here doesn't make sense as object won't be valid - missing form_answer
    invite = PalaceInvite.where(email: email).first_or_create
    Users::BuckinghamPalaceInviteMailer.invite(invite.id).deliver_later!
  end
end
