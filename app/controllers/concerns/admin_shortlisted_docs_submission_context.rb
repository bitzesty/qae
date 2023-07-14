module AdminShortlistedDocsSubmissionContext
  def create
    authorize resource, :submit?

    resource.submitted? ? resource.uncomplete : resource.complete

    respond_to do |format|
      format.html do
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
    @resource ||= (form_answer.shortlisted_documents_wrapper || form_answer.build_shortlisted_documents_wrapper)

    return @resource if @resource.persisted?
    
    @resource.save!
    @resource
  end
end
