module AssessmentSubmissionMixin
  def create
    authorize resource, :submit?
    @service = AssessmentSubmissionService.new(resource)
    @service.perform

    respond_to do |format|
      format.json { render(json_response) }
      format.html do
        redirect_to [namespace_name, resource.form_answer]
      end
    end
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
