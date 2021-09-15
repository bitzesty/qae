module Scheduled
  class EmailNotificationServiceWorker < BaseWorker
    sidekiq_options retry: 0

    def perform
      ::Notifiers::EmailNotificationService.run
    end
  end
end
