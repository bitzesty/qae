module Scheduled
  class PerformancePlatformServiceWorker < BaseWorker
    def perform
      ::PerformancePlatformService.run
    end
  end
end
