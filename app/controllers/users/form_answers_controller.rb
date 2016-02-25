class Users::FormAnswersController < Users::BaseController

  expose(:form_answer) do
    current_user.account
                .form_answers
                .find(params[:id])
  end

  expose(:pdf_blank_mode) do
    params[:pdf_blank_mode].present?
  end

  before_action do
    allow_assessor_access!(form_answer)
  end

  def show
    if can_render_pdf_on_fly?
      respond_to do |format|
        format.pdf do
          pdf = form_answer.decorate.pdf_generator(pdf_blank_mode)
          send_data pdf.render,
                    filename: form_answer.decorate.pdf_filename,
                    type: "application/pdf"
        end
      end
    else
      render_hard_copy_pdf
    end
  end

  private

  def can_render_pdf_on_fly?
    !form_answer.submission_ended?
  end

  def render_hard_copy_pdf
    if form_answer.pdf_version.present?
      redirect_to form_answer.pdf_version.url
    else
      redirect_to dashboard_path,
                  notice: "PDF version for your application is not available!"
    end
  end
end
