class Assessor::FormAnswersController < Assessor::BaseController
  def index
    authorize :form_answer, :index?

    scope = current_assessor.assigned_to_forms
    @search = FormAnswerSearch.new(scope).search(params[:search])
    @form_answers = @search.results.page(params[:page])
  end
end
