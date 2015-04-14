require 'securerandom'

class PopulateScanAssociationsForExistingAttachments
  class << self
    def run
      AuditCertificate.all.each do |entry|
        if entry.scan.blank?
          Scan.create(
            filename: entry.attachment.current_path,
            uuid: SecureRandom.hex(30),
            audit_certificate_id: entry.id,
            status: "clean"
          )
        end
      end

      FormAnswerAttachment.all.each do |entry|
        if entry.scan.blank?
          Scan.create(
            filename: entry.file.current_path,
            uuid: SecureRandom.hex(30),
            form_answer_attachment_id: entry.id,
            status: "clean"
          )
        end
      end

      SupportLetterAttachment.all.each do |entry|
        if entry.scan.blank?
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
end
