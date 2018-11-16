class Assessor::FormAnswersController < Assessor::BaseController
  include FormAnswerMixin

  before_action :load_resource, only: [:update_financials]

  expose(:financial_pointer) do
    FormFinancialPointer.new(@form_answer, {
      exclude_ignored_questions: true,
      financial_summary_view: true
    })
  end

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :case_summary_assessment,
                :category_picker

  def index
    authorize :form_answer, :index?
    params[:search] ||= {
      sort: "company_or_nominee_name",
      search_filter: {
        status: FormAnswerStatus::AssessorFilter::checked_options.invert.values
      }
    }
    params[:search].permit!
    scope = current_assessor.applications_scope(@award_year)

    if params[:search][:query].blank? && category_picker.show_award_tabs_for_assessor?
      scope = scope.where(award_type: category_picker.current_award_type)
    end

    @search = FormAnswerSearch.new(scope, current_assessor).search(params[:search])
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by
    @form_answers = @search.results
                      .with_comments_counters
                      .group("form_answers.id")
                      .page(params[:page])
  end

  private

  def resource
    @form_answer ||= current_assessor.applications_scope.find(params[:id]).decorate
  end

  def category_picker
    CurrentAwardTypePicker.new(current_subject, params)
  end
end
