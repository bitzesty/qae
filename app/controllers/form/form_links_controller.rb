class Form::FormAttachmentsAndLinksController < Form::BaseController

  # This controller handles saving of website links
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.opts[:id] == :add_website_address_documents_step }
  end

  expose(:existing_materials) do
    JSON.parse(@form_answer.document["innovation_materials"])
  end

  expose(:next_document_position) do
    existing_materials.keys.map(&:to_i).max + 1
  end

  expose(:form_link) do
    FormLink.new
  end

  def new
  end

  def create
    self.form_link = FormLink.new(link_params)
    form_link.valid?

    render :index
  end

  def destroy

    render :index
  end

  private
    def link_params
      params.require(:form_link).permit(
        :link,
        :position,
        :description
      )
    end
end
