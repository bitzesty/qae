require "virus_scanner"
class FormAnswerAttachment < ActiveRecord::Base
  belongs_to :form_answer
  belongs_to :attachable, polymorphic: true
  has_one :scan, class_name: Scan
  after_save :virus_scan

  mount_uploader :file, FormAnswerAttachmentUploader

  scope :uploaded_by_user, -> { where attachable_type: "User" }
  scope :uploaded_not_by_user, -> { where.not(attachable_type: "User") }

  # Used for NON JS implementation - begin
  attr_accessor :non_js_creation, :description
  # Should be 100 words maximum
  validates :description, presence: true,
                          length: {
                            maximum: 100,
                            tokenizer: -> (str) { str.split },
                            message: "is too long (maximum is 100 words)"
                          },
                          on: :create,
                          if: "self.non_js_creation.present?"
  # Used for NON JS implementation - end

  begin :validations
    validates :form_answer_id, presence: true
    validates :file, presence: true,
                     file_size: {
                       maximum: 5.megabytes.to_i
                     }
  end

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
    if ENV["DISABLE_VIRUS_SCANNER"] == "true"
      Scan.create(
        filename: file.current_path,
        uuid: SecureRandom.uuid,
        audit_certificate_id: id,
        status: "clean"
      )
    else
      response = ::VirusScanner::File.scan_url(file.url)
      Scan.create(
        filename: file.current_path,
        uuid: response["id"],
        status: response["status"],
        audit_certificate_id: id
      )
    end
  end
end
