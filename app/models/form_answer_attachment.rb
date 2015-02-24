class FormAnswerAttachment < ActiveRecord::Base
  belongs_to :form_answer
  belongs_to :attachable, polymorphic: true

  mount_uploader :file, FormAnswerAttachmentUploader

  def filename
    read_attribute(:file)
  end

  def created_by_admin?
    attachable.blank? || attachable.try(:admin?)
  end
end
