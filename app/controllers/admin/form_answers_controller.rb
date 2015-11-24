class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin

  before_filter :load_resource, only: [:review, :show, :update, :update_financials]

  expose(:financial_pointer) do
    FormFinancialPointer.new(@form_answer, {
      exclude_ignored_questions: true,
      financial_summary_view: true
    })
  end

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(@award_year.form_answers, current_admin).search(params[:search])
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by
    @form_answers = @search.results.group("form_answers.id")
                                   .page(params[:page])
                                   .includes(:comments)
  end

  private

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :case_summary_assessment

  def resource
    @form_answer ||= load_resource
  end
end
