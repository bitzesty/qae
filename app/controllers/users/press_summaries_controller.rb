class Users::PressSummariesController < Users::BaseController
  before_action :check_deadline

  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:form_answer_id])
  end

  def show
    @press_summary = form_answer.press_summary
    @press_summary.first_name   ||= current_user.first_name
    @press_summary.last_name    ||= current_user.last_name
    @press_summary.email        ||= current_user.email
    @press_summary.phone_number ||= current_user.phone_number
  end

  def update
    @press_summary = form_answer.press_summary
    @press_summary.reviewed_by_user = true
    if @press_summary.update_attributes(press_summary_params)
      flash.notice = "Press Comment successfully updated"
      redirect_to action: :show
    else
      render :show
    end
  end

  private

  def press_summary_params
    params.require(:press_summary).permit(
      :comment, :correct, :phone_number, :first_name, :last_name, :email
    )
  end

  def check_deadline
    if settings.deadlines.where(kind: "press_release_comments").first.passed?
      flash.alert = "Sorry, you can not amend press release comments anymore"
      redirect_to dashboard_url
    end
  end
end
