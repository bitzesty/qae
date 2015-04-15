class Form::MaterialsBaseController < Form::BaseController

  # This controller handles saving of attachments and website links
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.opts[:id] == :add_website_address_documents_step }
  end

  expose(:innovation_materials_doc) do
    @form_answer.document["innovation_materials"]
  end

  expose(:existing_materials) do
    Rails.logger.info "[innovation_materials_doc] #{innovation_materials_doc}"
    if innovation_materials_doc.present?
      JSON.parse(innovation_materials_doc)
    else
      {}
    end
  end

  expose(:next_document_position) do
    existing_materials.keys.map(&:to_i).max.to_i + 1
  end
end
