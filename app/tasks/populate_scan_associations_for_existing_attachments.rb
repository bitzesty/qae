class PopulateScanAssociationsForExistingAttachments
  class << self
    def run
      AuditCertificate.all.each do |entry|
        Scan.create(
          filename: entry.attachment.current_path,
          uuid: entry.id,
          audit_certificate_id: entry.id,
          status: "clean"
        )
      end

      FormAnswerAttachment.all.each do |entry|
        Scan.create(
          filename: entry.file.current_path,
          uuid: entry.id,
          form_answer_attachment_id: entry.id,
          status: "clean"
        )
      end

      SupportLetterAttachment.all.each do |entry|
        Scan.create(
          filename: entry.attachment.current_path,
          uuid: entry.id,
          support_letter_attachment_id: entry.id,
          status: "clean"
        )
      end
    end
  end
end
