class Admin::FeedbacksController < Admin::BaseController
  after_action :log_event, only: [:create, :update, :destroy, :submit, :unlock]
  include FeedbackMixin

  expose(:form_answer) do
    @form_answer
  end

  expose(:pdf_data) do
    @form_answer.decorate.feedbacks_pdf_generator
  end

  expose(:pdf_hard_copy) do
    @form_answer.feedback_hard_copy_pdf
  end

  def download_pdf
    authorize @form_answer, :download_feedback_pdf?

    respond_to do |format|
      format.pdf do
        admin_conditional_pdf_response("feedback")
      end
    end
  end
end
