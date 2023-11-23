module AssessmentSubmissionMixin
  def create
    authorize resource, :submit?
    @service = AssessmentSubmissionService.new(resource, current_subject)
    @service.perform
    log_event if resource.reload.locked_at.present?

    respond_to do |format|
      format.json { render(json_response) }
      format.html do
        render_flash_message_for(resource, message: flash_message)
        redirect_to [namespace_name, resource.form_answer]
      end
    end
  end

  def unlock
    authorize resource, :can_unlock?
    resource.update_column(:locked_at, nil)
    form_answer.state_machine.perform_simple_transition(:assessment_in_progress) if resource.moderated?
    log_event

    render_flash_message_for(resource, message: flash_message)
    redirect_to [namespace_name, resource.form_answer]
  end

  def action_type
    appraisal_type = resource.position == "case_summary" ? "case_summary" : "#{resource.position}_appraisal"
    appraisal_action = action_name == "create" ? "submit" : "unsubmit"
    "#{appraisal_type}_#{appraisal_action}"
  end

  def form_answer
    resource.form_answer
  end

  private

  def flash_message
    return nil if resource.errors.none?
    resource.errors.full_messages.join("<br />")
  end

  def json_response
    json = @service.as_json
    resp = { json: @service.errors }
    resp[:status] = :unprocessable_entity if json.present?
    resp
  end

  def resource
    @assignment ||= AssessorAssignment.find(params[:assessment_id])
  end
end
