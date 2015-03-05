class AuditCertificateUploader < FileUploader
  def extension_white_list
    %w(csv jpg)
  end
end
