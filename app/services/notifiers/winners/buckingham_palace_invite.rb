class Notifiers::Winners::BuckinghamPalaceInvite
  include Shoryuken::Worker

  shoryuken_options queue: "#{Rails.env}_default", auto_delete: true, body_parser: :json

  def perform(sqs_msg, ops)
    email = ops["email"]
    form_answer_id = ops["form_answer_id"]

    invite = PalaceInvite.where(email: email, form_answer_id: form_answer_id).first_or_create
    Users::BuckinghamPalaceMailer.invite(invite.id).deliver_later!
  end
end
