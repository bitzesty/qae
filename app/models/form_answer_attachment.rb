require 'virus_scanner'
class FormAnswerAttachment < ActiveRecord::Base
  belongs_to :form_answer
  belongs_to :attachable, polymorphic: true
  after_save :virus_scan
  has_one :scan, class_name: Scan

  mount_uploader :file, FormAnswerAttachmentUploader

  scope :uploaded_by_user, -> { where attachable_type: "User" }
  scope :uploaded_not_by_user, -> { where.not(attachable_type: "User") }

  def filename
    read_attribute(:file)
  end

  def created_by_admin?
    attachable.blank? || attachable.is_a?(Admin)
  end

  def self.visible_for(subject)
    out = all
    out = all.where(restricted_to_admin: false) unless subject.is_a?(Admin)
    out
  end

  def uploaded_not_by_user?
    attachable_type != "User"
  end

  def virus_scan
    scan = ::VirusScanner::File.scan_url(self.file.url)
    Scan.create(filename: self.file.current_path, uuid: scan["id"], form_answer_attachment_id: self.id)
  end
end
