class Form::MaterialsBaseController < Form::BaseController
  # This controller handles saving of attachments and website links
  # This section is used in case if JS disabled
  MAX_ATTACHMENTS = 3

  expose(:step) do
    @form.steps.detect { |s| s.opts[:id] == :add_website_address_documents_step }
  end

  expose(:innovation_materials_doc) do
    @form_answer.document["innovation_materials"]
  end

  expose(:existing_materials) do
    innovation_materials_doc.presence || {}
  end

  expose(:next_document_position) do
    existing_materials.keys.map(&:to_i).max.to_i + 1
  end

  before_action :check_materials_limit, only: [:create]

  private

  def check_materials_limit
    if existing_materials.count >= MAX_ATTACHMENTS
      redirect_to form_form_answer_form_attachments_url(@form_answer),
        alert: "You can add up to #{MAX_ATTACHMENTS} files or website addresses as maximum!"
      nil
    end
  end
end
