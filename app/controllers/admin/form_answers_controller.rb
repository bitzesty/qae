class Admin::FormAnswersController < Admin::BaseController
  before_filter :load_resource, only: [:withdraw, :review, :show]

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?
    @search = FormAnswerSearch.new(FormAnswer.all).search(params[:search])
    @form_answers = @search.results.page(params[:page])
  end


  def show
    authorize @form_answer, :show?
  end

  def withdraw
    authorize @form_answer, :withdraw?
    @form_answer.toggle!(:withdrawn)
    redirect_to action: :index
  end

  def review
    authorize @form_answer, :review?
    sign_in(@form_answer.user, bypass: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(@form_answer, anchor: "company-information")
  end

  private

  def load_resource
    @form_answer = FormAnswer.find(params[:id])
  end
end
