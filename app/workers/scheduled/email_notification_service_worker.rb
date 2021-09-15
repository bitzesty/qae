module Scheduled
  class EmailNotificationServiceWorker < BaseWorker
    def perform
      ::Notifiers::EmailNotificationService.run
    end
  end
end
