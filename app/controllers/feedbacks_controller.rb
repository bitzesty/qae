class FeedbacksController < ApplicationController
  def show
    @feedback = SiteFeedback.new
  end

  def create
    @feedback = SiteFeedback.new(feedback_params)

    if @feedback.save
      redirect_to current_user ? dashboard_path : root_path,
                  notice: "Feedback was successfully sent"
    else
      render :show
    end
  end

  private

  def feedback_params
    if params[:site_feedback]
      params.require(:site_feedback).permit(:rating, :comment)
    else
      {}
    end
  end
end
