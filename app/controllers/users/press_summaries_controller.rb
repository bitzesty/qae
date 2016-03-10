class Users::PressSummariesController < Users::BaseController
  skip_before_action :authenticate_user!

  before_action :check_deadline, :load_press_summary, except: [:success, :failure]
  before_action :check_promotion_award_acceptance,
                except: [:acceptance, :update_acceptance, :success, :failure]

  before_action :require_press_summary_to_be_not_submitted_by_user!, only: [:show, :update]

  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id])
  end
  expose(:award) do
    form_answer.decorate
  end
  expose(:employees_figure) do
    if financial_pointer.present?
      financial_pointer[:employees].reverse.detect do |data|
        data[:value].present? && data[:value] != "-"
      end
    end
  end

  def update
    @press_summary.reviewed_by_user = true
    @press_summary.applicant_submitted = params[:submit].present?

    if @press_summary.update(press_summary_params)
      if @press_summary.applicant_submitted?
        flash.notice = "Press Book Notes successfully submitted"
        redirect_to dashboard_url
      else
        flash.notice = "Press Book Notes successfully updated"
        redirect_to action: :show, token: params[:token]
      end
    else
      render :show
    end
  end

  def update_acceptance
    if params[:form_answer][:accepted] == "true"
      form_answer.update(accepted: true)
      redirect_to action: :show, token: params[:token]
    else
      form_answer.update(accepted: false)
      redirect_to action: :success
    end
  end

  private

  def press_summary_params
    params.require(:press_summary).permit(
      :comment, :correct, :phone_number, :name, :email
    )
  end

  def check_deadline
    if settings.deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first.passed?
      redirect_to action: :failure
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

  def financial_pointer
    FormFinancialPointer.new(
      award,
      exclude_ignored_questions: true,
      financial_summary_view: true
    ).data.detect { |r| r[:employees].present? }
  end

  def require_press_summary_to_be_not_submitted_by_user!
    if @press_summary.applicant_submitted?
      redirect_to dashboard_url,
                  notice: "Press Summary already submitted!"
      return
    end
  end
end
