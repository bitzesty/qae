class AuditCertificateUploader < FileUploader
  def extension_white_list
    %w(csv)
  end
end
