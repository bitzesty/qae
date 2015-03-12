class Admin::AssessorAssignmentsController < Admin::BaseController
  def update
    assessment = AssessorAssignmentService.new(params, current_subject)
    authorize assessment.resource, :update?

    assessment.save

    respond_to do |format|
      format.js { render(nothing: true) }
      format.html { redirect_to(:back) }
    end
  end
end
