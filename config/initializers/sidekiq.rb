redis_url = if ENV["REDIS_URL"].present?
  ENV["REDIS_URL"]
elsif ENV['REDIS_ENV_LINK_PASSWORD'].present?
  # docker convox/redis_store image
  "#{ENV['REDIS_ENV_LINK_SCHEME']}://:#{ENV['REDIS_ENV_LINK_PASSWORD']}@#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}#{ENV['REDIS_ENV_LINK_PATH']}"
else
  "redis://localhost:6379/12"
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url
  }
end
