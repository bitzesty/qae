class Form::FormAttachmentsController < Form::MaterialsBaseController

  # This controller handles saving of attachments
  # This section is used in case if JS disabled

  expose(:form_answer_attachments) do
    current_user.form_answer_attachments
                .where(form_answer_id: @form_answer.id)
  end

  expose(:form_answer_attachment) do
    current_user.form_answer_attachments.new(
      form_answer_id: @form_answer.id
    )
  end

  expose(:created_attachment_ops) do
    {
      "file" => form_answer_attachment.id.to_s,
      "description" => attachment_params[:description]
    }
  end

  expose(:original_filename) do
    attachment_params[:file].present? ? attachment_params[:file].original_filename : nil
  end

  expose(:add_attachment_result_doc) do
    result_materials = existing_materials
    Rails.logger.info "[result_materials 1] #{result_materials}"

    Rails.logger.info "[next_document_position] #{next_document_position}"
    Rails.logger.info "[created_attachment_ops] #{created_attachment_ops}"
    result_materials[next_document_position.to_s] = created_attachment_ops

    Rails.logger.info "[result_materials 2] #{result_materials}"

    @form_answer.document.merge(
      innovation_materials: result_materials.to_json
    )
  end

  expose(:remove_attachment_result_doc) do
    result_materials = existing_materials.reject! do |k, v|
      v["file"] == form_answer_attachment.id.to_s
    end

    result_materials = result_materials.present? ? result_materials.to_json : ""

    Rails.logger.info "[result_materials remove] #{result_materials}"

    @form_answer.document.merge(
      innovation_materials: result_materials
    )
  end

  def index
  end

  def new
  end

  def create
    Rails.logger.info "[attachment_params] #{attachment_params}"
    self.form_answer_attachment = current_user.form_answer_attachments.new(
      attachment_params.merge({
        form_answer_id: @form_answer.id,
        non_js_creation: true,
        original_filename: original_filename
      })
    )

    if form_answer_attachment.save
      @form_answer.document = add_attachment_result_doc
      @form_answer.save

      redirect_to form_form_answer_form_attachments_url
    else
      Rails.logger.info "[form_answer_attachment] #{form_answer_attachment.errors.full_messages}"
      render :new
    end
  end

  def destroy
    remove_attachment_result_doc
    @form_answer.document = remove_attachment_result_doc

    if @form_answer.save
      form_answer_attachment.destroy
    end

    redirect_to form_form_answer_form_attachments_url
  end

  private

    def attachment_params
      params.require(:form_answer_attachment).permit(
        :file,
        :position,
        :description
      )
    end
end
