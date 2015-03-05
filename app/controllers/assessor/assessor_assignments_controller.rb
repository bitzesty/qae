class Assessor::AssessorAssignmentsController < Assessor::BaseController
  def create
    authorize :assessor_assignment, :create?
    assessor_assignment = AssessorAssignment.new(create_params)

    if current_assessor.can_assign_regular_assessors?(assessor_assignment)
      assessor_assignment.save
    end

    redirect_to :back # wireframes to be confirmed
  end

  def update
    authorize resource, :update?

    resource.update(create_params)
    redirect_to :back
  end

  private

  def create_params
    params.require(:assessor_assignment).permit :form_answer_id, :assessor_id, :position
  end

  def resource
    @assessor_assignment ||= AssessorAssignment.find(params[:id])
  end
end
