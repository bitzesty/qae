require 'securerandom'

class PopulateScanAssociationsForExistingAttachments
  class << self
    def run
      AuditCertificate.all.each do |entry|
        Scan.create(
          filename: entry.attachment.current_path,
          uuid: SecureRandom.hex(30),
          audit_certificate_id: entry.id,
          status: "clean"
        )
      end

      FormAnswerAttachment.all.each do |entry|
        Scan.create(
          filename: entry.file.current_path,
          uuid: SecureRandom.hex(30),
          form_answer_attachment_id: entry.id,
          status: "clean"
        )
      end

      SupportLetterAttachment.all.each do |entry|
        Scan.create(
          filename: entry.attachment.current_path,
          uuid: SecureRandom.hex(30),
          support_letter_attachment_id: entry.id,
          status: "clean"
        )
      end
    end
  end
end
