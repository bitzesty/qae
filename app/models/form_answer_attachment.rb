class FormAnswerAttachment < ActiveRecord::Base
  belongs_to :form_answer

  mount_uploader :file, FormAnswerAttachmentUploader
end
