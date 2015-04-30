class Users::FormAnswerFeedbacksController < Users::BaseController
  def show
    respond_to do |format|
      format.pdf do
        pdf = form_answer.feedbacks_pdf_generator
        send_data pdf.render,
                  filename: "application_feedback_#{form_answer.pdf_filename}",
                  type: "application/pdf"
      end
    end
  end

  private

  def form_answer
    @form_answer ||= resource.form_answer.decorate
  end

  def resource
    @form_answer_feedback ||= Feedback.find(params[:id])
  end
end
