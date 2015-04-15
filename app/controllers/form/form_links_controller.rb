class Form::FormLinksController < Form::MaterialsBaseController

  # This controller handles saving of website links
  # This section is used in case if JS disabled

  expose(:form_link) do
    FormLink.new
  end

  expose(:created_link_ops) do
    {
      "link" => link_params[:link],
      "description" => link_params[:description]
    }
  end

  expose(:add_link_result_doc) do
    result_materials = existing_materials
    Rails.logger.info "[result_materials 1] #{result_materials}"

    Rails.logger.info "[next_document_position] #{next_document_position}"
    Rails.logger.info "[created_link_ops] #{created_link_ops}"
    result_materials[next_document_position.to_s] = created_link_ops

    Rails.logger.info "[result_materials 2] #{result_materials}"

    @form_answer.document.merge(
      innovation_materials: result_materials.to_json
    )
  end

  expose(:remove_link_result_doc) do
    result_materials = existing_materials.reject! do |k, v|
      v["file"] == form_link.link
    end

    result_materials = result_materials.present? ? result_materials.to_json : ""

    Rails.logger.info "[result_materials remove] #{result_materials}"

    @form_answer.document.merge(
      innovation_materials: result_materials
    )
  end

  def new
  end

  def create
    Rails.logger.info "[link_params] #{link_params}"
    self.form_link = FormLink.new(link_params)

    if form_link.valid?
      @form_answer.document = add_link_result_doc
      @form_answer.save

      redirect_to form_form_answer_form_attachments_url
    else
      render :new
    end
  end

  def destroy
    @form_answer.document = remove_link_result_doc
    @form_answer.save

    redirect_to form_form_answer_form_attachments_url
  end

  private
    def link_params
      params.require(:form_link).permit(
        :link,
        :description
      )
    end
end
