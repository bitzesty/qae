class AuditCertificate < ActiveRecord::Base
  include VirusScannerCallbacks

  mount_uploader :attachment, AuditCertificateUploader
  has_one :scan, class_name: Scan

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

  before_save :clean_changes_description

  enum status: {
    no_changes_necessary: 0,
    confirmed_changes: 1
  }

  def reviewed?
    reviewed_at.present?
  end

  # Virus Scanner check after upload
  def store_attachment!
    super()
    virus_scan
  end

  private

  def clean_changes_description
    if status_changed? && status == "no_changes_necessary" && changes_description.present?
      self.changes_description = nil
    end
  end
end
