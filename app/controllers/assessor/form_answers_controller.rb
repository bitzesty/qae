class Assessor::FormAnswersController < Assessor::BaseController
  include FormAnswerMixin

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :lead_case_summary_assessment,
                :category_picker

  def index
    authorize :form_answer, :index?
    params[:search] ||= {
      sort: "company_or_nominee_name",
      search_filter: {
        status: FormAnswerStatus::AssessorFilter::OPTIONS.invert.values
      }
    }
    scope = current_assessor.applications_scope

    if params[:search][:query].blank? && category_picker.show_award_tabs_for_assessor?
      scope = scope.where(award_type: category_picker.current_award_type)
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

  def category_picker
    CurrentAwardTypePicker.new(current_subject, params)
  end
end
