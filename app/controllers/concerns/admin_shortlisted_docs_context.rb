module AdminShortlistedDocsContext
  def show
    authorize form_answer, :download_commercial_figures?

    send_data resource.attachment.read,
      filename: resource.attachment.file.filename,
      disposition: "attachment"
  end

  def create
    attachment = build_resource
    attachment.form_answer = form_answer

    authorize begin_of_association_chain, :create?

    if attachment.save
      log_event

      respond_to do |format|
        format.html do
          render_flash_message_for(attachment)
          redirect_to [namespace_name, form_answer]
        end

        format.js do
          render partial: "admin/figures_and_vat_returns/file",
            locals: { attachment: attachment },
            content_type: "text/plain"
        end
      end
    else
      respond_to do |format|
        format.html do
          render_flash_message_for(attachment)
          redirect_to [namespace_name, form_answer]
        end

        format.js do
          render partial: "admin/figures_and_vat_returns/form",
            locals: {
              form_answer: form_answer,
              attachment: attachment,
            },
            content_type: "text/plain",
            status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    authorize begin_of_association_chain, :destroy?
    log_event if resource.destroy

    respond_to do |format|
      format.html do
        if request.xhr? || request.format.js?
          head :ok
        else
          render_flash_message_for(resource)
          redirect_to [namespace_name, form_answer]
        end
      end
    end
  end

  private

  def action_type
    case action_name
    when "create"
      "#{permitted_params_key}_uploaded"
    when "destroy"
      "#{permitted_params_key}_destroyed"
    else
      raise "Attempted to log an unsupported action (#{action_name})"
    end
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def begin_of_association_chain
    @_begin_of_association_chain ||=
      (form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper)

    return @_begin_of_association_chain if @_begin_of_association_chain.persisted?

    @_begin_of_association_chain.save!
    @_begin_of_association_chain
  end

  def association_chain
    begin_of_association_chain.send(relationship_name)
  end

  def resource
    @_resource ||= resource_class.find(params[:id])
  end

  def build_resource
    association_chain.build(permitted_params)
  end

  def permitted_params_key
    resource_class.to_s.underscore
  end

  def permitted_params
    params.require(permitted_params_key).permit(:attachment)
  end
end
