module FormAnswerAttachmentsContext
  def create
    service = FormAnswerAttachmentService.new(params, current_subject)
    authorize service.resource, :create?

    if service.save
      log_event

      respond_to do |format|
        format.html do
          redirect_to [namespace_name, form_answer]
        end

        format.js do
          render service.for_js
        end
      end
    else
      respond_to do |format|
        format.html do
          redirect_to [namespace_name, form_answer],
                      alert: service.errors
        end

        format.js do
          render partial: "admin/form_answer_attachments/form",
                 locals: {
                   form_answer_attachment: service.resource,
                   form_answer:,
                 },
                 content_type: "text/plain",
                 status: :unprocessable_entity
        end
      end
    end
  end

  def show
    authorize resource, :show?
    send_data resource.file.read, filename: resource.filename, disposition: "attachment"
  end

  def destroy
    authorize resource, :destroy?
    log_event if resource.destroy

    respond_to do |format|
      format.html do
        if request.xhr? || request.format.js?
          head :ok
        else
          redirect_to [namespace_name, form_answer]
        end
      end
    end
  end

  private

  def action_type
    "form_answer_attachment_#{action_name}"
  end

  def resource
    @form_answer_attachment ||= form_answer.form_answer_attachments.find(params[:id])
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
