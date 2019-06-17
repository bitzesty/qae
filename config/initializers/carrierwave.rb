CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = PaasResolver.s3_config
    config.fog_directory = PaasResolver.s3_bucket
    config.storage = :fog
    config.fog_public = false
  else
    config.storage = :file
  end
end
