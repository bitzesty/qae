class Assessor::FormAnswersController < Assessor::BaseController
  helper_method :resource

  def index
    authorize :form_answer, :index?

    scope = current_assessor.applications_assigned_to_as

    @search = FormAnswerSearch.new(scope).search(params[:search])
    @form_answers = @search.results.page(params[:page])
  end

  def show
    authorize resource, :show?
  end

  private

  def resource
    @form_answer ||= current_assessor.applications_assigned_to_as.find(params[:id]).decorate
  end
end
