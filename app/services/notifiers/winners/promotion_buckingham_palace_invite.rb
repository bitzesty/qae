class Notifiers::Winners::PromotionBuckinghamPalaceInvite
  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(sqs_msg, ops={})
    email = ops[:email]
    form_answer_id = ops[:form_answer_id]

    invite = PalaceInvite.where(email: email, form_answer_id: form_answer_id).first_or_create
    Users::PromotionBuckinghamPalaceInviteMailer.notify(invite.id).deliver_later!
  end
end
