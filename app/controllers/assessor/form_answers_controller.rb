class Assessor::FormAnswersController < Assessor::BaseController
  include FormAnswerMixin

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :current_award_type,
                :lead_case_summary_assessment,
                :primary_case_summary_assessment,
                :visible_categories,
                :show_award_tabs_for_assessor?

  def index
    authorize :form_answer, :index?
    params[:search] ||= {
      sort: "company_or_nominee_name",
      search_filter: {
        status: FormAnswerStatus::AssessorFilter::OPTIONS.invert.values
      }
    }
    scope = current_assessor.applications_scope

    if params[:search][:query].blank? && show_award_tabs_for_assessor?
      scope = scope.where(award_type: current_award_type)
    end

    @search = FormAnswerSearch.new(scope, current_assessor).search(params[:search])
    @form_answers = @search.results.group("form_answers.id")
                                   .page(params[:page])
                                   .includes(:comments)
  end

  private

  def resource
    @form_answer ||= current_assessor.applications_scope.find(params[:id]).decorate
  end

  # Assessor categories tabs
  # TODO: tests, extract

  # If Assessor is a lead in at least one category
  # and is a lead or assigned as regular to another category
  # he sees the tabs with these categories displayed

  def current_award_type
    lead_categories = current_subject.categories_as_lead
    return nil if lead_categories.blank?
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

  def show_award_tabs_for_assessor?
    if current_subject.categories_as_lead.size > 0
      return true if visible_categories.size > 1
    end
  end
end
