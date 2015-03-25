class Assessor::PressSummariesController < Assessor::BaseController
  include PressSummaryMixin

  private

  def form_answers_scope
    current_assessor.applications_scope
  end
end
