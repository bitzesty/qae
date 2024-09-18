class FileScanJob < ApplicationJob
  queue_as :default

  def perform(key, class_name, record_id, attribute_name)
    record = class_name.constantize.find(record_id)
    file = record.send(attribute_name)

    return if file.blank?

    begin
      file_to_scan = get_file_to_scan(file)
      scan_result = VirusScanner.scan_file(file_to_scan)
      status = scan_result[:malware] ? "infected" : "clean"
      record.send(:"on_scan_#{attribute_name}", status: status)
    rescue VirusScanner::AuthenticationError => e
      handle_authentication_error(record, attribute_name, e)
    rescue VirusScanner::FileTooLargeError => e
      handle_file_too_large_error(record, attribute_name, e)
    rescue VirusScanner::ScanError => e
      handle_scan_error(record, attribute_name, e)
    ensure
      file_to_scan.close if file_to_scan.respond_to?(:close)
    end
  end

  private

  def get_file_to_scan(file)
    if file.is_a?(String)
      File.open(file, "rb")
    elsif file.respond_to?(:read)
      file
    elsif file.is_a?(CarrierWave::SanitizedFile)
      File.open(file.file, "rb")
    elsif file.respond_to?(:file)
      if file.file.is_a?(CarrierWave::SanitizedFile)
        File.open(file.file.file, "rb")
      elsif file.file.respond_to?(:path)
        File.open(file.file.path, "rb")
      elsif file.file.respond_to?(:read)
        file.file
      else
        raise ArgumentError, "Don't know how to handle #{file.file.class}"
      end
    elsif file.respond_to?(:path)
      File.open(file.path, "rb")
    else
      raise ArgumentError, "Don't know how to handle #{file.class}"
    end
  end

  def handle_authentication_error(record, attribute_name, error)
    Rails.logger.error("VirusScanner Authentication Error: #{error.message}")
    record.send(:"on_scan_#{attribute_name}", status: :error)
  end

  def handle_file_too_large_error(record, attribute_name, error)
    Rails.logger.warn("File too large for virus scanning: #{error.message}")
    record.send(:"on_scan_#{attribute_name}", status: :error)
  end

  def handle_scan_error(record, attribute_name, error)
    Rails.logger.error("VirusScanner Error: #{error.message}")
    record.send(:"on_scan_#{attribute_name}", status: :error)
  end
end
