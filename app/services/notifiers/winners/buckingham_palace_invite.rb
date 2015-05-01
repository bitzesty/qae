class Notifiers::Winners::BuckinghamPalaceInvite
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true

  def perform(sqs_msg, email, form_answer_id)
    invite = PalaceInvite.where(email: email, form_answer_id: form_answer_id).first_or_create
    Users::BuckinghamPalaceInviteMailer.invite(invite.id).deliver_later!
  end
end
