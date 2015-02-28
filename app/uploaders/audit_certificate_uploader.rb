class AuditCertificateUploader < FileUploader
  def extension_white_list
    %w(csv pdf)
  end
end
