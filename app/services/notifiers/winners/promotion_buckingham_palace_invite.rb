class Notifiers::Winners::PromotionBuckinghamPalaceInvite
  include Shoryuken::Worker

  shoryuken_options queue: "#{ENV['AWS_SQS_QUEUE_ADVANCED_PREFIX']}#{Rails.env}_default", auto_delete: true

  def perform(sqs_msg, email, form_answer_id)
    invite = PalaceInvite.where(email: email, form_answer_id: form_answer_id).first_or_create
    Users::PromotionBuckinghamPalaceInviteMailer.notify(invite.id).deliver_later!
  end
end
