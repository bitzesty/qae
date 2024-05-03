class FormAnswerPdfVersionUploader < CarrierWave::Uploader::Base
  def filename
    if original_filename.present?
      "#{original_filename.split("_SEPARATOR")[0]}.#{file.extension}"
    end
  end

  def extension_allowlist
    %w(pdf)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
