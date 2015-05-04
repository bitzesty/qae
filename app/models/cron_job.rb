class CronJobRun
  def self.run(lock_name, timeout_seconds=0, sleep_before_run=5, &block)
    User.with_advisory_lock(lock_name, timeout_seconds) do
      sleep(sleep_before_run) if sleep_before_run.to_i > 0
      block.call
    end
  end
end
