module ShortlistedDocument
  extend ActiveSupport::Concern

  included do
    include ScanFiles

    mount_uploader :attachment, AuditCertificateUploader

    scan_for_viruses :attachment

    belongs_to :form_answer, optional: true
  end

  def original_filename
    attachment.file&.filename
  end
end
