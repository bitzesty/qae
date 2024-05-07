require "sidekiq/throttled"

class MailDeliveryWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Job

  sidekiq_throttle(threshold: { limit: 1_000, period: 1.hour })

  def perform(mailer, mail_method, delivery_method, *args)
    mailer_class = mailer.safe_constantize
    message = mailer_class.public_send(mail_method, *args)
    message.send(delivery_method)
  end
end
