class Admin::UsersFeedbacksController < Admin::BaseController
  def show
    authorize :users_feedback, :show?
    @feedbacks = SiteFeedback.all.order(created_at: :desc).page(params[:page])
  end
end
