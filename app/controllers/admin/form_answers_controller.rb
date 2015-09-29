class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin

  before_filter :load_resource, only: [:review, :show, :update, :update_financials]

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(@award_year.form_answers, current_admin).search(params[:search])

    @form_answers = @search.results.group("form_answers.id")
                                   .page(params[:page])
                                   .includes(:comments)
  end

  private

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :lead_case_summary_assessment

  def resource
    @form_answer ||= load_resource
  end
end
