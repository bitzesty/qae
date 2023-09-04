module DraftNotesMixin
  def create
    resource = form_answer.build_draft_note(create_params)
    authorize resource, :create?

    resource.authorable = current_subject

    resource.save!

    respond_to do |format|
      format.html do
        render_flash_message_for(resource)
        redirect_to [namespace_name, form_answer]
      end

      format.json do
        render json: {}
      end
    end
  end

  def update
    resource = DraftNote.find(params[:id])
    authorize resource, :update?

    resource.assign_attributes(create_params)
    resource.authorable = current_subject
    resource.save!

    respond_to do |format|
      format.html do
        render_flash_message_for(resource)
        redirect_to [namespace_name, form_answer]
      end

      format.json do
        render json: {}
      end
    end
  end

  private

  def create_params
    params.require(:draft_note).permit(:content)
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
