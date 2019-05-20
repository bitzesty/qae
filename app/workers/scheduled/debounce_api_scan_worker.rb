module Scheduled
  class DebounceApiScanWorker < BaseWorker
    def perform
      User.debounce_scan_candidates.find_each.map do |user|
        CheckAccountOnBouncesEmail.new(
          user
        ).run!

        sleep 0.5
      end
    end
  end
end
