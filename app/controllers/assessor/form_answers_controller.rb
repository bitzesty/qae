class Assessor::FormAnswersController < Assessor::BaseController
  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment

  def index
    authorize :form_answer, :index?

    scope = current_assessor.applications_assigned_to_as

    @search = FormAnswerSearch.new(scope).search(params[:search])
    @form_answers = @search.results.page(params[:page]).includes(:comments)
  end

  def show
    authorize resource, :show?
  end

  private

  def resource
    @form_answer ||= current_assessor.applications_assigned_to_as.find(params[:id]).decorate
  end

  def primary_assessment
    @primary_assessment ||= resource.assessor_assignments.primary.decorate
  end

  def secondary_assessment
    @secondary_assessment ||= resource.assessor_assignments.secondary.decorate
  end

  def moderated_assessment
    if current_subject.lead?(resource)
      @moderated_assessment ||= resource.assessor_assignments.moderated.decorate
    end
  end
end
