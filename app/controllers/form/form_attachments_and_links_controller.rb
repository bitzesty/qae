class Form::FormAttachmentsAndLinksController < Form::BaseController

  # This controller handles saving of attachments and website links
  # This section is used in case if JS disabled

  expose(:form_answer_attachments) do
    @form_answer.form_answer_attachments
  end

  expose(:existing_materials) do
    JSON.parse(@form_answer.document["innovation_materials"])
  end

  expose(:next_document_position) do
    existing_materials.keys.map(&:to_i).max + 1
  end

  expose(:new_form_link) do
    FormLink.new
  end

  expose(:new_form_answer_attachment) do
    current_user.form_answer_attachments.new(
      form_answer: @form_answer
    )
  end

  def index
  end

  def create
    if params[:document_type] == "attachment"
      @form_answer_attachment = current_user.form_answer_attachments.new(
        attachment_params.merge({
          form_answer: @form_answer
        })
      )
      if @form_answer_attachment.save

      end
    else
      @form_link = FormLink.new(link_params)
      @form_link.valid?
    end

    render :index
  end

  def update
  end

  def destroy
  end

  private

    def attachment_params
      params.require(:form_answer_attachment).permit(
        :file,
        :position,
        :description
      )
    end

    def link_params
      params.require(:form_link).permit(
        :link,
        :position,
        :description
      )
    end
end
