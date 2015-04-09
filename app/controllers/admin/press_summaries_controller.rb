class Admin::PressSummariesController < Admin::BaseController
  include PressSummaryMixin

  private

  def form_answers_scope
    @award_year.form_answers
  end
end
