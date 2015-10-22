class Users::FormAnswersController < Users::BaseController
  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:id])
  end

  expose(:original_form_answer) do
    form_answer.original_form_answer
  end

  expose(:pdf_blank_mode) do
    params[:pdf_blank_mode].present?
  end

  before_action do
    allow_assessor_access!(form_answer)
  end

  def show
    respond_to do |format|
      format.pdf do
        pdf = original_form_answer.decorate.pdf_generator(pdf_blank_mode)
        send_data pdf.render,
                  filename: original_form_answer.decorate.pdf_filename,
                  type: "application/pdf"
      end
    end
  end
end
