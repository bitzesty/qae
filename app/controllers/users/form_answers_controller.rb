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

  before_action :log_download_action, only: :show

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

  def log_download_action
    if admin_in_read_only_mode?
      # { warden.user.user.key => [[1], "$2a$10$KItas1NKsvunK0O5w9ioWu"] }
      subject = if admin_signed_in?
        Admin.find(session["warden.user.admin.key"][0][0])
      else
        Assessor.find(session["warden.user.assessor.key"][0][0])
      end

      AuditLog.create!(subject: subject, action_type: "download_form_answer", auditable: form_answer)
    end
  end

  def can_render_pdf_on_fly?
    !form_answer.submission_ended?
  end

  def render_hard_copy_pdf
    if form_answer.pdf_version.present?
      redirect_to form_answer.pdf_version.url
    else
      if !admin_in_read_only_mode?
        redirect_to dashboard_path,
                    notice: "PDF version for your application is not available!"
      else
        redirect_to :back, notice: "PDF version for your application is not available!"
      end
    end
  end
end
