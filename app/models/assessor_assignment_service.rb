class AssessorAssignmentService
  attr_reader :params, :current_subject, :resource

  def initialize(params, current_subject)
    @params = params
    @current_subject = current_subject
    @resource = AssessorAssignment.find(params[:id])
    normalize_params
  end

  def save
    resource.assign_attributes(update_params)
    resource.editable = current_subject
    resource.assessed_at = DateTime.now unless assignment_request?
    resource.save
  end

  def permitted_params
    permitted = Assessment::AppraisalForm.all
    permitted += assignment_params if current_subject.lead?(form_answer)
    permitted
  end

  def update_params
    params.require(:assessor_assignment).permit(*permitted_params)
  end

  private

  def normalize_params
    update_params.delete_if { |_, v| v.blank? }
  end

  def assignment_request?
    (update_params.keys.map(&:to_s) & assignment_params.map(&:to_s)).present?
  end

  def assignment_params
    [:assessor_id, :position]
  end

  def form_answer
    @form_answer ||= FormAnswer.find(resource.form_answer_id)
  end
end
