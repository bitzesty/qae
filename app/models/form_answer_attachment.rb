class FormAnswerAttachment < ActiveRecord::Base
  include VirusScannerCallbacks

  belongs_to :form_answer
  belongs_to :attachable, polymorphic: true
  has_one :scan, class_name: Scan

  mount_uploader :file, FormAnswerAttachmentUploader

  scope :uploaded_by_user, -> { where attachable_type: "User" }
  scope :uploaded_not_by_user, -> { where.not(attachable_type: "User") }

  # Used for NON JS implementation - begin
  attr_accessor :non_js_creation, :description
  # Should be 100 words maximum (limit + 10%).to_i + 1)
  validates :description, presence: true,
                          length: {
                            maximum: 111,
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

  # Virus Scanner check after upload
  def store_file!
    super()
    virus_scan
  end
end
