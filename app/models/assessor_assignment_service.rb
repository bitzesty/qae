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
    handle_with_form_answer_transition
    resource.save
  end

  def permitted_params
    permitted = AppraisalForm.all
    permitted += assignment_params if admin_or_lead?
    permitted
  end

  def update_params
    params.require(:assessor_assignment).permit(*permitted_params)
  end

  private

  def admin_or_lead?
    current_subject.is_a?(Admin) || current_subject.try(:lead?, form_answer)
  end

  def handle_with_form_answer_transition
    if resource.moderated? && admin_or_lead?
      # get the state from the overall verdict
      # TODO: as we collect more information about next phases need to add
      # more strict logic in states transitions + permissions as I can imagine
      # that lead assessor is not permitted to change the state assigned by PM
      form_answer.state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
    end
  end

  def normalize_params
    params[:assessor_assignment].delete_if { |_, v| v.blank? }
  end

  def assignment_request?
    (update_params.keys.map(&:to_s) & assignment_params.map(&:to_s)).present?
  end

  def assignment_params
    [:assessor_id]
  end

  def form_answer
    @form_answer ||= FormAnswer.find(resource.form_answer_id)
  end
end
