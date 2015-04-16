require "virus_scanner"
class AuditCertificate < ActiveRecord::Base
  mount_uploader :attachment, AuditCertificateUploader
  has_one :scan, class_name: Scan
  after_save :virus_scan

  begin :associations
    belongs_to :form_answer
    belongs_to :reviewable, polymorphic: true
  end

  begin :validations
    validates :form_answer_id, uniqueness: true,
                               presence: true
    validates :attachment, presence: true,
                           file_size: {
                             maximum: 5.megabytes.to_i
                           }
    validates :reviewable_type,
              :reviewable_id,
              :reviewed_at,
              presence: true,
              if: :reviewed?
  end

  enum status: {
    no_changes_necessary: 0,
    confirmed_changes: 1
  }

  def reviewed?
    reviewed_at.present?
  end

  def virus_scan
    if ENV["DISABLE_VIRUS_SCANNER"] == "true"
      Scan.create(
        filename: attachment.current_path,
        uuid: SecureRandom.uuid,
        audit_certificate_id: id,
        status: "clean"
      )
    else
      response = ::VirusScanner::File.scan_url(attachment.url)
      Scan.create(
        filename: attachment.current_path,
        uuid: response["id"],
        status: response["status"],
        audit_certificate_id: id
      )
    end
  end
end
