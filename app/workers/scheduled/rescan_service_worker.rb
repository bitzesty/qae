module Scheduled
  class RescanServiceWorker < BaseWorker
    def perform
      RescanService.perform
    end
  end
end
