class FormAnswerAttachmentDecorator < ApplicationDecorator
  def display_name
    object.title.presence || object.filename
  end
end
