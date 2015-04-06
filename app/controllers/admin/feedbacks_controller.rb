class Admin::FeedbacksController < Admin::BaseController
  include FeedbackMixin

  expose(:pdf_data) do
    @form_answer.decorate.feedbacks_pdf_generator
  end

  def download_pdf
    authorize @feedback, :download_pdf?

    respond_to do |format|
      format.pdf do
        send_data pdf_data.render,
                  filename: "application_feedbacks_#{@form_answer.decorate.pdf_filename}",
                  type: "application/pdf"
      end
    end
  end

  private

  def form_answers_scope
    FormAnswer
  end
end
