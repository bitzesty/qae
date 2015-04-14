require 'virus_scanner'
class SupportLetterAttachment < ActiveRecord::Base
  mount_uploader :attachment, FormAnswerAttachmentUploader
  has_one :scan, class_name: Scan
  after_save :virus_scan

  begin :associations
    belongs_to :user
    belongs_to :form_answer
    belongs_to :support_letter
  end

  begin :validations
    validates :form_answer, :user, presence: true
    validates :attachment, presence: true,
                           file_size: {
                             maximum: 5.megabytes.to_i
                           }
  end

  def virus_scan
    if ENV["DISABLE_VIRUS_SCANNER"] == "true"
      Scan.create(filename: self.attachment.current_path, uuid: SecureRandom.uuid, support_letter_attachment_id: self.id, status: "clean")
    else
      scan = ::VirusScanner::File.scan_url(self.attachment.url)
      Scan.create(filename: self.attachment.current_path, uuid: scan["id"], support_letter_attachment_id: self.id)
    end
  end
end
