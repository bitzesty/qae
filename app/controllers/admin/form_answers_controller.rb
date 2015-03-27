class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin

  before_filter :load_resource, only: [:review, :show, :update, :update_financials]

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(FormAnswer.all, current_admin).search(params[:search])

    @form_answers = @search.results.uniq.page(params[:page]).includes(:comments)
  end

  def show
    authorize @form_answer, :show?
  end

  def update_financials
    authorize @form_answer, :update_financials?
    @form_answer.financial_data = params[:financial_data]
    @form_answer.financial_data["updated_at"] = Time.zone.now
    @form_answer.financial_data["updated_by_id"] = current_admin.id
    @form_answer.financial_data["updated_by_type"] = current_admin.class

    @form_answer.save

    if request.xhr?
      head :ok, content_type: "text/html"

      return
    else
      flash.notice = "Financial data updated"
      redirect_to action: :show
      return
    end
  end

  def review
    authorize @form_answer, :review?
    sign_in(@form_answer.user, bypass: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(@form_answer)
  end

  private

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :primary_case_summary_assessment,
                :lead_case_summary_assessment

  def resource
    @form_answer ||= load_resource
  end

  def load_resource
    @form_answer = FormAnswer.find(params[:id]).decorate
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
