class Form::FormAttachmentsController < Form::MaterialsBaseController

  # This controller handles saving of attachments
  # This section is used in case if JS disabled (destroy action used for both JS and NON JS)

  expose(:form_answer_attachments) do
    @form_answer.form_answer_attachments
  end

  expose(:form_answer_attachment) do
    current_user.form_answer_attachments.new(
      form_answer_id: @form_answer.id
    )
  end

  expose(:created_attachment_ops) do
    {
      "file" => form_answer_attachment.id.to_s,
      "description" => attachment_params[:description],
    }
  end

  expose(:original_filename) do
    attachment_params[:file].present? ? attachment_params[:file].original_filename : nil
  end

  expose(:add_attachment_result_doc) do
    result_materials = existing_materials
    result_materials[next_document_position.to_s] = created_attachment_ops

    @form_answer.document.merge(
      innovation_materials: result_materials
    )
  end

  expose(:remove_attachment_result_doc) do
    result_materials = existing_materials
    result_materials.delete_if do |k, v|
      v["file"] == params[:id].to_s
    end
    result_materials = result_materials.present? ? result_materials : {}

    @form_answer.document.merge(
      innovation_materials: result_materials
    )
  end

  def index
  end

  def new
  end

  def create
    self.form_answer_attachment = current_user.form_answer_attachments.new(
      attachment_params.merge({
        form_answer_id: @form_answer.id,
        non_js_creation: true,
        original_filename: original_filename,
      })
    )

    if form_answer_attachment.save
      @form_answer.document = add_attachment_result_doc
      @form_answer.save

      redirect_to edit_form_url(id: @form_answer.id, step: "supplementary-materials-confirmation")
    else
      render :new
    end
  end

  def confirm_deletion
    self.form_answer_attachment = self.form_answer_attachments.find(params[:form_attachment_id])
  end

  def destroy
    self.form_answer_attachment = form_answer_attachments.find(params[:id])

    @form_answer.document = remove_attachment_result_doc
    if @form_answer.save
      form_answer_attachment.destroy
    end

    respond_to do |format|
      format.html do
        if request.xhr? || request.format.js?
          head :ok
        else
          redirect_to edit_form_url(id: @form_answer.id, step: "supplementary-materials-confirmation")
        end
      end
    end
  end

  private

    def attachment_params
      params.require(:form_answer_attachment).permit(
        :file,
        :description
      )
    end
end
