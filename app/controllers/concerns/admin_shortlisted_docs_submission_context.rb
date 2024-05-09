module AdminShortlistedDocsSubmissionContext
  def create
    authorize resource, :submit?

    if resource.submitted?
      resource.uncomplete
    else
      if resource.complete
        if form_answer.assessors.primary.present?
          Assessors::GeneralMailer.vat_returns_submitted(form_answer.id).deliver_later!
        end

        Users::CommercialFiguresMailer.notify(form_answer.id, form_answer.account.owner_id).deliver_later!
      end
    end

    respond_to do |format|
      format.html do
        render_flash_message_for(resource)

        redirect_to [namespace_name, form_answer], alert: render_errors
      end

      format.js
    end
  end

  private

  def render_errors
    resource.errors.full_messages.join(", ") if resource.errors.any?
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def resource
    @resource ||= form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper

    return @resource if @resource.persisted?

    @resource.save!
    @resource
  end
end
