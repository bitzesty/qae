class Assessor::AssessorAssignmentsController < Assessor::BaseController
  def update
    authorize resource, :update?
    # auth
    resource.assign_attributes(create_params)
    resource.editable = current_subject
    resource.assessed_at = DateTime.now unless assignment_request?
    resource.save

    respond_to do |format|
      format.js do
        render nothing: true
      end
      format.html do
        redirect_to :back
      end
    end
  end

  private

  def create_params
    params[:assessor_assignment].delete_if { |_, v| v.blank? }
    permitted = Assessment::AppraisalForm.all
    permitted += assignment_params if current_subject.lead?(form_answer)
    params.require(:assessor_assignment).permit(*permitted)
  end

  def assignment_request?
    (params[:assessor_assignment].keys & assignment_params).present?
  end

  def assignment_params
    [:form_answer_id, :assessor_id, :position]
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:assessor_assignment][:form_answer_id])
  end

  def resource
    @assessor_assignment ||= AssessorAssignment.find(params[:id])
  end
end
