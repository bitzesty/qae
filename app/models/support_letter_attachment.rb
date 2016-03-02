class SupportLetterAttachment < ActiveRecord::Base
  mount_uploader :attachment, FormAnswerAttachmentUploader
  scan_file :attachment

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
end
