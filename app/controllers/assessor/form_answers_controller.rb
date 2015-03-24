class Assessor::FormAnswersController < Assessor::BaseController
  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :current_award_type,
                :lead_case_summary_assessment,
                :primary_case_summary_assessment,
                :visible_categories

  def index
    authorize :form_answer, :index?
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH

    scope = current_assessor.applications_scope

    if params[:search][:query].blank? && current_subject.categories_as_lead.size > 1
      scope = scope.where(award_type: current_award_type)
    end

    @search = FormAnswerSearch.new(scope, current_assessor).search(params[:search])
    @form_answers = @search.results.page(params[:page]).includes(:comments)
  end

  def show
    authorize resource, :show?
  end

  def review
    authorize resource, :review?
    sign_in(resource.user, bypass: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(resource)
  end

  private

  def resource
    @form_answer ||= current_assessor.applications_scope.find(params[:id]).decorate
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

  def current_award_type
    lead_categories = current_subject.categories_as_lead
    return nil if lead_categories.blank?
    # only lead can see the tabs to display separated categories
    regular_categories = current_subject.applications_scope.pluck(:award_type).uniq
    categories = lead_categories + regular_categories
    if params[:award_type].present?
      params[:award_type] if categories.include?(params[:award_type])
    else
      categories.first
    end
  end

  def visible_categories
    lead_categories = current_subject.categories_as_lead
    regular_categories = current_subject.applications_scope.pluck(:award_type).uniq
    (lead_categories + regular_categories).uniq
  end
end
