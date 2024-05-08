class SupportLetterAttachment < ApplicationRecord
  mount_uploader :attachment, FormAnswerAttachmentUploader
  scan_file :attachment

  include ::InfectedFileCleaner
  clean_after_scan :attachment

  begin :associations
    belongs_to :user, optional: true
    belongs_to :form_answer, optional: true
    belongs_to :support_letter, optional: true
  end

  begin :validations
    validates :form_answer, :user, presence: true
    validates :attachment, presence: true,
      on: :create,
      file_size: {
        maximum: 5.megabytes.to_i,
      }
  end
end
