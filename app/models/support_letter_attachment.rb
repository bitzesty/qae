class SupportLetterAttachment < ActiveRecord::Base
  mount_uploader :attachment, FormAnswerAttachmentUploader

  begin :associations
    belongs_to :user
    belongs_to :form_answer
  end

  begin :validations
    validates :form_answer, :user, presence: true
    validates :attachment, presence: true,
                           file_size: {
                             maximum: 5.megabytes.to_i
                           }
  end
end
