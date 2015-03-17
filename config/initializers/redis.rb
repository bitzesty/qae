$redis = Redis.new(
  host: ENV["AWS_ELASTIC_CACHE_REDIS_CLUSTER_HOST"] || "localhost",
  port: ENV["AWS_ELASTIC_CACHE_REDIS_CLUSTER_PORT"] || "6379"
)

if Rails.env.staging? || Rails.env.production?
  Rails.application.configure do
    config.cache_store = :redis_store, {
      host: ENV["AWS_ELASTIC_CACHE_REDIS_CLUSTER_HOST"],
      port: ENV["AWS_ELASTIC_CACHE_REDIS_CLUSTER_PORT"],
      expires_in: 1.day
    }
  end
end
