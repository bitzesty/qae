class FormAnswerPdfVersionUploader < CarrierWave::Uploader::Base
  def filename
    return if original_filename.blank?

    "#{original_filename.split("_SEPARATOR")[0]}.#{file.extension}"
  end

  def extension_whitelist
    %w[pdf]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
