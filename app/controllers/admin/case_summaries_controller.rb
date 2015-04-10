class Admin::CaseSummariesController < Admin::BaseController
  expose(:form_answer) do
    FormAnswer.find(params[:form_answer_id]).decorate
  end

  expose(:pdf_data) do
    form_answer.decorate.case_summaries_pdf_generator
  end

  def index
    authorize form_answer, :download_case_summary_pdf?

    respond_to do |format|
      format.pdf do
        send_data pdf_data.render,
                  filename: "application_case_summaries_#{form_answer.decorate.pdf_filename}",
                  type: "application/pdf"
      end
    end
  end
end
