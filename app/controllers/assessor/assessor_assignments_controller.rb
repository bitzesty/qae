class Assessor::AssessorAssignmentsController < Assessor::BaseController
  def update
    authorize resource, :update?

    assessment = AssessorAssignmentService.new(params, current_subject)
    assessment.save

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

  def resource
    @assessor_assignment ||= AssessorAssignment.find(params[:id])
  end
end
