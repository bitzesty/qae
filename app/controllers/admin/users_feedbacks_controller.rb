class Admin::UsersFeedbacksController < Admin::BaseController
  def show
    authorize :users_feedback, :show?
    @feedbacks = SiteFeedback.all.page(params[:page])
  end
end
