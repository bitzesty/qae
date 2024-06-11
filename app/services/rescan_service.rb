class RescanService
  def self.perform
    rescan_model(SupportLetterAttachment, :attachment)
    rescan_model(FormAnswerAttachment, :file)
    rescan_model(AuditCertificate, :attachment)
  end

  def self.rescan_model(attachment_class, attachment_column)
    attachment_class.where.not("#{attachment_column}_scan_results" => %w[infected clean]).each do |record|
      record.public_send(:"scan_#{attachment_column}!")
    end
  end
end
