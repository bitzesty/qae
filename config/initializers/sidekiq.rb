Sidekiq.configure_server do |config|
  config.logger = Appsignal::Logger.new("sidekiq")
  config.logger.formatter = Sidekiq::Logger::Formatters::WithoutTimestamp.new

  config.redis = { url: CredentialsResolver.redis_uri }
end

Sidekiq.configure_client do |config|
  config.redis = { url: CredentialsResolver.redis_uri }
end
