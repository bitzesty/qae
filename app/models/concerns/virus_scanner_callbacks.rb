require "virus_scanner"

module VirusScannerCallbacks
  def mounted_file_namespace
    if self.class.to_s == "FormAnswerAttachment"
      "file"
    else
      "attachment"
    end
  end

  def foreign_key_id
    self.class.to_s.underscore + "_id"
  end

  def common_attrs
    ops = {
      filename: self.send(mounted_file_namespace).current_path,
      uuid: SecureRandom.uuid,
      status: (ENV["DISABLE_VIRUS_SCANNER"] == "true" ? "clean" : "scanning")
    }

    ops[foreign_key_id.to_sym] = self.id

    ops
  end

  def virus_scan
    scan = Scan.create!(common_attrs)

    unless ENV["DISABLE_VIRUS_SCANNER"] == "true"
      response = ::VirusScanner::File.scan_url(
        scan.uuid,
        self.send(mounted_file_namespace).url)

      scan.update(vs_id: response["id"], status: response["status"])
    end
  end
end
