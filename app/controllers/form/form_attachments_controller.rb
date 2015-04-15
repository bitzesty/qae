class Form::FormAttachmentsController < Form::BaseController

  # This controller handles saving of attachments
  # This section is used in case if JS disabled

  expose(:step) do
    @form.steps.detect { |s| s.opts[:id] == :add_website_address_documents_step }
  end

  expose(:form_answer_attachments) do
    current_user.form_answer_attachments
                .where(form_answer_id: @form_answer.id)
  end

  expose(:existing_materials) do
    JSON.parse(@form_answer.document["innovation_materials"])
  end

  expose(:next_document_position) do
    existing_materials.keys.map(&:to_i).max + 1
  end

  expose(:form_answer_attachment) do
    current_user.form_answer_attachments.new(
      form_answer_id: @form_answer.id
    )
  end

  def index
  end

  def new
  end

  def create
    Rails.logger.info "[attachment_params] #{attachment_params}"
    # self.form_answer_attachment = current_user.form_answer_attachments.new(
    #   attachment_params.merge({
    #     form_answer_id: @form_answer.id
    #   })
    # )

    # if form_answer_attachment.save
    #   # Save to form_answer
    # end

    render :index
  end

  def destroy
    render :index
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
