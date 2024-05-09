module Extensions
  module ActionMailer
    module MessageDeliveryDecorator
      def enqueue_delivery(delivery_method, options = {})
        if processed?
          ::Kernel.raise "You've accessed the message before asking to " \
            "deliver it later, so you may have made local changes that would " \
            "be silently lost if we enqueued a job to deliver it. Why? Only " \
            "the mailer method *arguments* are passed with the delivery job! " \
            "Do not access the message in any way if you mean to deliver it " \
            "later. Workarounds: 1. don't touch the message before calling " \
            "#deliver_later, 2. only touch the message *within your mailer " \
            "method*, or 3. use a custom Active Job instead of #deliver_later."
        else
          job_class = @mailer_class.delivery_job
          perform_method = job_class.respond_to?(:perform_async) ? :perform_async : perform_later

          job_class.set(options).send(perform_method, @mailer_class.name, @action.to_s, delivery_method.to_s, *@args)
        end
      end
    end
  end
end

if ::ActionMailer::MessageDelivery.included_modules.exclude?(Extensions::ActionMailer::MessageDeliveryDecorator)
  ::ActionMailer::MessageDelivery.prepend(Extensions::ActionMailer::MessageDeliveryDecorator)
end

