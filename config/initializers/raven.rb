require 'raven'

logger = ::Logger.new(STDOUT)
logger.level = ::Logger::WARN

Raven.configure do |config|
  config.environments = %w[production]
  config.logger = logger
end
