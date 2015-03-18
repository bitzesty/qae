class Admin::FeedbacksController < Admin::BaseController
  include FeedbackMixin

  private

  def form_answers_scope
    FormAnswer
  end
end
