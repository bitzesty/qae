class Assessor::FeedbacksController < Assessor::BaseController
  include FeedbackMixin

  private

  def form_answers_scope
    current_assessor.applications_scope
  end
end
