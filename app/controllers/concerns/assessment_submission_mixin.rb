module AssessmentSubmissionMixin
  def create
    authorize resource, :submit?
    @service = AssessmentSubmissionService.new(resource, current_subject)
    @service.perform

    respond_to do |format|
      format.json { render(json_response) }
      format.html do
        redirect_to [namespace_name, resource.form_answer]
      end
    end
  end

  def unlock
    authorize resource, :can_unlock?
    resource.update_column(:locked_at, nil)

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

  def json_response
    json = @service.as_json
    resp = { json: json }
    resp[:status] = :unprocessable_entity if json.present?
    resp
  end

  def resource
    @assignment ||= AssessorAssignment.find(params[:assessment_id])
  end
end
