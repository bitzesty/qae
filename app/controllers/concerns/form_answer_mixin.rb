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
            legend: resource.decorate.average_growth_legend,
          },
        }
      end

      format.html do
        if request.xhr? || request.format.js?
          render partial: "admin/form_answers/company_details/#{params[:section]}_form", layout: false
        else
          redirect_to [namespace_name, resource]
        end
      end
    end
  end

  def update_financials
    authorize @form_answer, :update_financials?
    @form_answer.financial_data = financial_data_ops
    @form_answer.save

    if request.xhr? || request.format.js?
      head :ok, content_type: "text/html"

      nil
    else
      flash.notice = "Financial data updated"
      redirect_to action: :show
      nil
    end
  end

  def show
    authorize resource, :show?

    @form_paginator = FormPaginator.new(@form_answer, current_subject, params)
  end

  def review
    authorize resource, :review?
    sign_in(@form_answer.user, scope: :user, skip_session_limitable: true)
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

  def case_summary_assessment
    @case_summary_assessment ||= resource.assessor_assignments.case_summary.decorate
  end

  def allowed_params
    ops = params.require(:form_answer).permit(*PermittedParams::FORM_ANSWER)
    ops = ops.to_h

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

  def load_resource
    @form_answer = FormAnswer.find(params[:id]).decorate
  end

  def financial_data_ops
    {
      updated_at: Time.zone.now,
      updated_by_id: pundit_user.id,
      updated_by_type: pundit_user.class,
    }.merge(params[:financial_data].permit(*PermittedParams::FINANCIAL_DATA))
  end
end
