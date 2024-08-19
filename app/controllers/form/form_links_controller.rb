class Form::FormLinksController < Form::MaterialsBaseController
  # This controller handles saving of website links
  # This section is used in case if JS disabled

  expose(:form_link) do
    FormLink.new
  end

  expose(:created_link_ops) do
    {
      "link" => link_params[:link],
      "description" => link_params[:description],
    }
  end

  expose(:add_link_result_doc) do
    result_materials = existing_materials
    result_materials[next_document_position.to_s] = created_link_ops

    @form_answer.document.merge(
      innovation_materials: result_materials,
    )
  end

  expose(:remove_link_result_doc) do
    result_materials = existing_materials
    result_materials.delete_if do |k, v|
      v["link"] == params[:link]
    end
    result_materials = result_materials.presence || {}

    @form_answer.document.merge(
      innovation_materials: result_materials,
    )
  end

  def new; end

  def create
    self.form_link = FormLink.new(link_params)

    if form_link.valid?
      @form_answer.document = add_link_result_doc
      @form_answer.save

      redirect_to edit_form_url(id: @form_answer.id, step: "supplementary-materials-confirmation")
    else
      render :new
    end
  end

  def confirm_deletion
    self.form_link = FormLink.new(link_params)
  end

  def destroy
    @form_answer.document = remove_link_result_doc
    @form_answer.save

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

  def link_params
    params.require(:form_link).permit(
      :link,
      :description,
    )
  end
end
