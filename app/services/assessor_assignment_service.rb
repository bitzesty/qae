class AssessorAssignmentService
  attr_reader :params, :current_subject, :resource
  DESC_REGEX = /_desc$/
  RATE_REGEX = /_rate$/

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
    permitted = AppraisalForm.all
    permitted += assignment_params if admin_or_lead?
    permitted
  end

  private

  def update_params
    params.require(:assessor_assignment).permit(*permitted_params)
  end

  def admin_or_lead?
    current_subject.is_a?(Admin) || current_subject.try(:lead?, form_answer)
  end

  def normalize_params
    p = params[:assessor_assignment]
    p.delete_if { |k, v| v.blank? && k != "assessor_id" }
    if updated_section.present?
      # Because every text field has separated submit form button
      # but there is only single huge form for all of the descriptions
      # it's needed to updated only description marked explicitly by the admin
      # to achieve data other description fields should be removed from params
      if DESC_REGEX.match?(updated_section)
        p.delete_if { |k, _| k =~ DESC_REGEX && k != updated_section }
      elsif RATE_REGEX.match?(updated_section)
        p.delete_if { |k, _| k != updated_section && (k =~ DESC_REGEX || k =~ RATE_REGEX) }
      end
    end
  end

  def updated_section
    params[:updated_section]
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
