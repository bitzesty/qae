class Admin::FormAnswersController < Admin::BaseController
  before_filter :find_form_answer, only: [:withdraw]

  def index
    @form_answers = FormAnswer.order(id: :desc).page(params[:page])
  end

  def withdraw
    @form_answer.toggle!(:withdrawn)
    redirect_to action: :index
  end

  private

  def find_form_answer
    @form_answer = FormAnswer.find(params[:id])
  end
end
