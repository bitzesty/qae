module FormAnswerAttachmentsContext
  def create
    service = FormAnswerAttachmentService.new(params, current_subject)
    authorize service.resource, :create?

    if service.save
      respond_to do |format|
        format.html do
          if request.xhr?
            render service.for_js
          else
            redirect_to [namespace_name, form_answer]
          end
        end
      end
    end
  end

  def show
    authorize resource, :show?
    send_data resource.file.read, filename: resource.filename, disposition: "inline"
  end

  def destroy
    authorize resource, :destroy?
    resource.destroy

    respond_to do |format|
      format.html do
        if request.xhr?
          render nothing: true
        else
          redirect_to [namespace_name, form_answer]
        end
      end
    end
  end

  private

  def resource
    @form_answer_attachment ||= form_answer.form_answer_attachments.find(params[:id])
  end

  def form_answer
    @form_answer ||= @award_year.form_answers.find(params[:form_answer_id])
  end
end
