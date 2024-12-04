require "carrierwave"
require "carrierwave/storage/fog"
require "fog/aws"

class CustomStorage
  def self.new(uploader)
    if Rails.env.production? || ENV["ENABLE_VIRUS_SCANNER_BUCKETS"] == "true"
      CustomFogStorage.new(uploader)
    else
      CustomFileStorage.new(uploader)
    end
  end
end

class CustomFogStorage < CarrierWave::Storage::Fog
end

class CustomFileStorage < CarrierWave::Storage::File
  def retrieve!(identifier)
    file = super
    if file.respond_to?(:uploader) && file.uploader.model.respond_to?(:clean?) && file.uploader.model.clean?
      new_path = file.path.sub("/tmp/", "/permanent/")
      FileUtils.mkdir_p(File.dirname(new_path))
      FileUtils.mv(file.path, new_path) unless File.exist?(new_path)
      file.instance_variable_set(:@path, new_path)
    end
    file
  end
end

CarrierWave.configure do |config|
  if Rails.env.production? || ENV["ENABLE_VIRUS_SCANNER_BUCKETS"] == "true"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_TMP_BUCKET_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_TMP_BUCKET_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"],
    }
    config.fog_directory = ENV["AWS_S3_TMP_BUCKET"]
    config.storage = :fog
    config.fog_public = false
    config.cache_dir = "/tmp/carrierwave"
    config.cache_storage = :fog
  else
    config.storage = :file
    config.enable_processing = false if Rails.env.test?
    config.root = Rails.root.join("public")
    config.cache_dir = "uploads/tmp"
    config.cache_storage = :file
  end
  config.storage_engines = { custom: "CustomStorage" }
end
