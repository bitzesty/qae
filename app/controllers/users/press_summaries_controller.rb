class Users::PressSummariesController < Users::BaseController
  skip_before_action :authenticate_user!

  before_action :check_deadline, :load_press_summary
  before_action :check_promotion_award_acceptance, except: [:acceptance, :update_acceptance]

  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id])
  end

  def update
    @press_summary.reviewed_by_user = true

    if @press_summary.update_attributes(press_summary_params)
      flash.notice = "Press Comment successfully updated"
      redirect_to action: :show, token: params[:token]
    else
      render :show
    end
  end

  def update_acceptance
    if params[:form_answer][:accepted] == "true"
      form_answer.update_column(:accepted, true)
      redirect_to action: :show, token: params[:token]
    else
      form_answer.update_column(:accepted, false)
      redirect_to root_url
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
      redirect_to root_url
    end
  end

  def check_promotion_award_acceptance
    if form_answer.promotion? && !form_answer.accepted?
      redirect_to action: :acceptance, token: params[:token]
    end
  end

  def load_press_summary
    @press_summary = form_answer.press_summary

    head :forbidden if @press_summary.token != params[:token]
  end
end
