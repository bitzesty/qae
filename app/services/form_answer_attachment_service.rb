class FormAnswerAttachmentService
  attr_reader :params, :subject, :resource

  def initialize(params, subject)
    @params = params
    @subject = subject

    @resource = form_answer.form_answer_attachments.build(create_params)
  end

  def save
    resource.attachable = subject
    resource.save
  end

  def for_js
    {
      partial: "admin/form_answer_attachments/form_answer_attachment",
      locals: {
        form_answer_attachment: resource,
        form_answer: form_answer
      }
    }
  end

  private

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def create_params
    params[:form_answer_attachment].permit(:file)
  end
end
