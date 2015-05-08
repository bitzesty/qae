class SupportLetterAttachment < ActiveRecord::Base
  include VirusScannerCallbacks

  mount_uploader :attachment, FormAnswerAttachmentUploader
  has_one :scan, class_name: Scan

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

  # Virus Scanner check after upload
  def store_attachment!
    super()
    virus_scan
  end
end
