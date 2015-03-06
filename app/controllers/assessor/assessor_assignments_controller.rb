class Assessor::AssessorAssignmentsController < Assessor::BaseController
  def create
    authorize :assessor_assignment, :create?
    assessor_assignment = AssessorAssignment.new(create_params)

    if current_assessor.lead?(form_answer)
      assessor_assignment.save
    end

    redirect_to :back # wireframes to be confirmed
  end

  def update
    authorize resource, :update?
    # auth
    resource.update(create_params)

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
    permitted = Assessment::AppraisalForm.all
    permitted += [:form_answer_id, :assessor_id, :position] if current_assessor.lead?(form_answer)
    params.require(:assessor_assignment).permit(*permitted)
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:assessor_assignment][:form_answer_id])
  end

  def resource
    @assessor_assignment ||= AssessorAssignment.find(params[:id])
  end
end
