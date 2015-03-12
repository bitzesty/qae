class Admin::AssessmentSubmissionsController < Assessor::BaseController
  def create
    @assignment = AssessorAssignment.find(params[:assessment_id])

    authorize @assignment, :submit?
    @assignment.submit_assessment

    respond_to do |format|
      format.json { render(json_response) }
      format.html { redirect_to admin_form_answer_path(@assignment.form_answer) }
    end
  end

  private

  def json_response
    json = @assignment.as_json
    resp = { json: json }
    resp[:status] = :unprocessable_entity if json.present?
    resp
  end
end
