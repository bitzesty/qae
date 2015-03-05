class Admin::FormAnswersController < Admin::BaseController
  before_filter :load_resource, only: [:withdraw, :review, :show, :update_financials]

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

  def update_financials
    authorize @form_answer, :update_financials?
    @form_answer.financial_data = params[:financial_data]
    @form_answer.financial_data['updated_at'] = Time.zone.now
    @form_answer.financial_data['updated_by_id'] = current_admin.id

    @form_answer.save

    if request.xhr?
      head :ok, content_type: "text/html"

      return
    else
      flash.notice = "Financial data updated"
      redirect_to action: :show
      return
    end
  end

  def review
    authorize @form_answer, :review?
    sign_in(@form_answer.user, bypass: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(@form_answer, anchor: "company-information")
  end

  private

  def load_resource
    @form_answer = FormAnswer.find(params[:id]).decorate
  end
end
