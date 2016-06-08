module Scheduled
  class BaseWorker
    include Sidekiq::Worker
    sidekiq_options backtrace: true
  end
end
