module FormAnswerMixin
  def update
    authorize resource, :update?
    resource.assign_attributes(update_params)
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

  private

  def update_params
    params.require(:form_answer).permit(
      :sic_code,
      :company_or_nominee_name,
      previous_wins_attributes: [:id, :year, :category, :_destroy]
    )
  end

  def primary_assessment
    @primary_assessment ||= resource.assessor_assignments.primary.decorate
  end

  def secondary_assessment
    @secondary_assessment ||= resource.assessor_assignments.secondary.decorate
  end

  def moderated_assessment
    @moderated_assessment ||= resource.assessor_assignments.moderated.decorate
  end

  def primary_case_summary_assessment
    @primary_case_summary_assessment ||= resource.assessor_assignments.primary_case_summary.decorate
  end

  def lead_case_summary_assessment
    @lead_case_summary_assessment ||= resource.assessor_assignments.lead_case_summary.decorate
  end
end
