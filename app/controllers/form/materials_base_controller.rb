class Form::MaterialsBaseController < Form::BaseController

  # This controller handles saving of attachments and website links
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
end
