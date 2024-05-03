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
                    type: "application/pdf",
                    disposition: "attachment"
        end
      end
    else
      render_hard_copy_pdf
    end
  end

  private

  def log_download_action
    return unless admin_in_read_only_mode?

    subject = if admin_signed_in?
                current_admin
              else
                current_assessor
              end

    AuditLog.create!(subject:, action_type: "download_form_answer", auditable: form_answer)
  end

  def can_render_pdf_on_fly?
    #
    # Render PDF on fly only if:
    #
    # 1) 'Download blank PDF'
    #
    # 2) Submission IS NOT ended for current application award year
    #
    # 3) Submission IS ended for current application award year,
    #    but application is not submitted and
    #    application's award year equal current award year (because
    #    PDF formatting changes from year to year and we can' generate
    #    PDF on fly for previous award years)
    #

    pdf_blank_mode ||
      !form_answer.submission_ended? ||
      (
        form_answer.submission_ended? &&
        !form_answer.submitted? &&
        form_answer.award_year_id == AwardYear.current.id
      )
  end

  def render_hard_copy_pdf
    if form_answer.pdf_version.present?
      redirect_to form_answer.pdf_version.url, allow_other_host: true
    elsif !admin_in_read_only_mode?
      redirect_to dashboard_path,
                  notice: "PDF version for your application is not available!"
    else
      flash[:notice] = "PDF version for your application is not available!"
      redirect_back(fallback_location: root_path)
    end
  end
end
