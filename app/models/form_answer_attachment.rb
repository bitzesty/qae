class FormAnswerAttachment < ActiveRecord::Base
  attr_accessor :file, :description, :link
  belongs_to :form

  mount_uploader :file, FormAnswerAttachmentUploader
end
