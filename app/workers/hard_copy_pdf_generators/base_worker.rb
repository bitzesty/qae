module HardCopyPdfGenerators
  class BaseWorker
    include Sidekiq::Worker
    sidekiq_options backtrace: true
  end
end
