class Admin::AssessorAssignmentsController < Admin::BaseController
  def update
    authorize AssessorAssignment.find(params[:id]), :update?

    assessment = AssessorAssignmentService.new(params, current_subject)
    assessment.save

    respond_to do |format|
      format.js { render(nothing: true) }
      format.html { redirect_to(:back) }
    end
  end
end
