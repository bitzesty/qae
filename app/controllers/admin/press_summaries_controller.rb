class Admin::PressSummariesController < Admin::BaseController
  include PressSummaryMixin

  private

  def form_answers_scope
    FormAnswer
  end
end
