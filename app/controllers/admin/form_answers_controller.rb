class Admin::FormAnswersController < Admin::BaseController
  before_filter :load_resource, only: [:withdraw, :review, :show, :update]

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(FormAnswer.all).search(params[:search])

    @form_answers = @search.results.page(params[:page])
  end

  def show
    authorize @form_answer, :show?
  end

  def update
    authorize @form_answer, :update?

    @form_answer.update(update_params)
    respond_to do |format|
      format.json do
        @form_answer = @form_answer.decorate
        render json: {
          form_answer: {
            sic_codes: @form_answer.all_average_growths,
            legend: @form_answer.average_growth_legend
          }
        }
      end

      format.html { redirect_to admin_form_answer_path(@form_answer) }
    end
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

  helper_method :resource

  def resource
    @form_answer ||= load_resource
  end

  def load_resource
    @form_answer = FormAnswer.find(params[:id]).decorate
  end

  def update_params
    params.require(:form_answer).permit(:sic_code)
  end
end
