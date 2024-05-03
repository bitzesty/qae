CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID", nil),
      aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY", nil),
      region: ENV.fetch("AWS_REGION", nil),
    }
    config.fog_directory = ENV.fetch("AWS_S3_BUCKET_NAME", nil)
    config.storage = :fog
    config.cache_storage = :file
    config.cache_dir = Rails.root.join "tmp/uploads"
    config.fog_public = false
  else
    config.storage = :file
    config.cache_storage = :file
    config.cache_dir = Rails.root.join "tmp/uploads"
  end
end
