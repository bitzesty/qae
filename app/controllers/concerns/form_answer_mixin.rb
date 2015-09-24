module FormAnswerMixin
  def update
    check_rigths_by_updating_options

    resource.assign_attributes(allowed_params.except(:data_attributes))
    resource.data_attributes = allowed_params[:data_attributes].except(:id) if allowed_params[:data_attributes]
    resource.company_details_updated_at = DateTime.now
    resource.company_details_editable = current_subject

    resource.save

    respond_to do |format|
      format.json do
        render json: {
          form_answer: {
            sic_codes: resource.decorate.all_average_growths,
            legend: resource.decorate.average_growth_legend
          }
        }
      end

      format.html do
        if request.xhr?
          render partial: "admin/form_answers/company_details/#{params[:section]}_form", layout: false
        else
          redirect_to [namespace_name, resource]
        end
      end
    end
  end

  def show
    authorize resource, :show?
  end

  def review
    authorize resource, :review?
    sign_in(@form_answer.user, bypass: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(@form_answer)
  end

  private

  def primary_assessment
    @primary_assessment ||= resource.assessor_assignments.primary.decorate
  end

  def secondary_assessment
    @secondary_assessment ||= resource.assessor_assignments.secondary.decorate
  end

  def moderated_assessment
    @moderated_assessment ||= resource.assessor_assignments.moderated.decorate
  end

  def lead_case_summary_assessment
    @lead_case_summary_assessment ||= resource.assessor_assignments.lead_case_summary.decorate
  end

  def allowed_params
    ops = params.require(:form_answer).permit!

    ops.reject! do |k, v|
      (k.to_sym == :company_or_nominee_name || k.to_sym == :nominee_title) &&
      !CompanyDetailPolicy.new(pundit_user, resource).can_manage_company_name?
    end

    ops
  end

  def its_previous_wins_update?
    params[:section] == "previous_wins"
  end

  def its_sic_code_update?
    params[:section] == "sic_code"
  end

  def check_rigths_by_updating_options
    if its_previous_wins_update? || its_sic_code_update?
      authorize resource, :can_update_by_admin_lead_and_primary_assessors?
    else
      authorize resource, :update?
    end
  end
end
