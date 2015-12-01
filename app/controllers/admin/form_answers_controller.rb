class Admin::FormAnswersController < Admin::BaseController
  include FormAnswerMixin

  before_filter :load_resource, only: [
    :review,
    :show,
    :update,
    :update_financials,
    :original_pdf_before_deadline
  ]

  expose(:financial_pointer) do
    FormFinancialPointer.new(@form_answer, {
      exclude_ignored_questions: true,
      financial_summary_view: true
    })
  end

  expose(:original_form_answer) do
    @form_answer.original_form_answer
  end

  expose(:pdf_data) do
    original_form_answer.decorate.pdf_generator
  end

  expose(:pdf_filename) do
    "original_pdf_before_deadline_#{@form_answer.decorate.pdf_filename}"
  end

  def index
    params[:search] ||= FormAnswerSearch::DEFAULT_SEARCH
    authorize :form_answer, :index?

    @search = FormAnswerSearch.new(@award_year.form_answers, current_admin).search(params[:search])
    @search.ordered_by = "company_or_nominee_name" unless @search.ordered_by
    @form_answers = @search.results.group("form_answers.id")
                                   .page(params[:page])
                                   .includes(:comments)
  end

  def original_pdf_before_deadline
    authorize @form_answer, :can_download_original_pdf_of_application_before_deadline?

    respond_to do |format|
      format.pdf do
        send_data pdf_data.render,
                  filename: pdf_filename,
                  type: "application/pdf"
      end
    end
  end

  private

  helper_method :resource,
                :primary_assessment,
                :secondary_assessment,
                :moderated_assessment,
                :case_summary_assessment

  def resource
    @form_answer ||= load_resource
  end
end
