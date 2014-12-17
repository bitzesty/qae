class Admin::FormAnswersController < Admin::BaseController
  before_filter :find_form_answer, only: [:withdraw, :review]

  def index
    @form_answers = FormAnswer.order(id: :desc).page(params[:page])
  end

  def withdraw
    @form_answer.toggle!(:withdrawn)
    redirect_to action: :index
  end

  def review
    sign_in(@form_answer.user, bypass: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(@form_answer, anchor: "company-information")
  end

  private

  def find_form_answer
    @form_answer = FormAnswer.find(params[:id])
  end
end
