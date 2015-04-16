class FormAnswerAttachmentUploader < FileUploader
  POSSIBLE_IMG_EXTENSIONS = %w(jpg jpeg gif png)

  def extension_white_list
    POSSIBLE_IMG_EXTENSIONS + %w(doc docx pdf pptx odt)
  end
end
