class AuditCertificateUploader < FileUploader

  def extension_white_list
    %w(doc docx pdf odt jpg jpeg gif png)
  end

end
