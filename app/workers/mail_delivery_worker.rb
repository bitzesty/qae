require "sidekiq/throttled"

class MailDeliveryWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Job

  sidekiq_throttle(
    threshold: {
      limit: ENV.fetch("MAIL_NOTIFY_THROTTLE_LIMIT") { 3_000 }.to_i,
      period: ENV.fetch("MAIL_NOTIFY_THROTTLE_PERIOD_IN_SECONDS") { 60 }.to_i.seconds
    }
  )

  def perform(mailer, mail_method, delivery_method, *args)
    mailer_class = mailer.safe_constantize
    message = mailer_class.public_send(mail_method, *args)
    message.send(delivery_method)
  end
end
