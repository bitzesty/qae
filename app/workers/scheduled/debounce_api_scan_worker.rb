module Scheduled
  class DebounceApiScanWorker < BaseWorker
    def perform
      User.debounce_scan_candidates.find_each.map do |user|
        user.check_email_on_bounces!

        sleep 0.5
      end
    end
  end
end
