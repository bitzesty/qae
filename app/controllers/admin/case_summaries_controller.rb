class Admin::CaseSummariesController < Admin::BaseController
  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id]).decorate
  end

  expose(:pdf_data) do
    form_answer.decorate.case_summaries_pdf_generator
  end

  expose(:pdf_hard_copy) do
    form_answer.case_summary_hard_copy_pdf
  end

  def index
    authorize form_answer, :download_case_summary_pdf?

    respond_to do |format|
      format.pdf do
        admin_conditional_pdf_response("case_summary")
      end
    end
  end
end
