class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin

  before_filter :load_resource, only: [:review, :show, :update, :update_financials]

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(@award_year.form_answers, current_admin).search(params[:search])

    @form_answers = @search.results.group("form_answers.id")
                                   .page(params[:page])
                                   .includes(:comments)
  end

  def update_financials
    authorize @form_answer, :update_financials?
    @form_answer.financial_data = financial_data_ops
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

  private

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :lead_case_summary_assessment

  def resource
    @form_answer ||= load_resource
  end

  def load_resource
    @form_answer = FormAnswer.find(params[:id]).decorate
  end

  def financial_data_ops
    {
      updated_at: Time.zone.now,
      updated_by_id: current_admin.id,
      updated_by_type: current_admin.class
    }.merge(params[:financial_data])
  end
end
