module ShortlistedDocument
  extend ActiveSupport::Concern

  included do
    mount_uploader :attachment, AuditCertificateUploader
    scan_file      :attachment

    include ::InfectedFileCleaner
    clean_after_scan :attachment

    belongs_to :form_answer, optional: true
  end

  def original_filename
    attachment.file&.filename
  end
end
