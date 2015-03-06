class Users::AuditCertificatesController < Users::BaseController
  before_action :check_certificate_if_exists, only: [:create]

  expose(:form_answer) do
    current_user.account.
                form_answers.
                find(params[:form_answer_id])
  end

  expose(:pdf_data) do
    form_answer.decorate.pdf_audit_certificate_generator
  end

  expose(:audit_certificate) do
    form_answer.audit_certificate
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        send_data pdf_data.render,
                  filename: "audit_certificate_#{form_answer.decorate.pdf_filename}",
                  type: "application/pdf"
      end
    end
  end

  def create
    self.audit_certificate = form_answer.build_audit_certificate(audit_certificate_params)

    if audit_certificate.save
      redirect_to users_form_answer_audit_certificate_path(form_answer),
                  notice: "Audit Certificate successfully uploaded!"
    else
      render :show
    end
  end

  private

    def audit_certificate_params
      # This is fix of "missing 'audit_certificate' param"
      # if no any file selected in file input
      if params[:audit_certificate].blank?
        params.merge!({
          audit_certificate: {
            attachment: ""
          }
        })
      end

      params.require(:audit_certificate).permit(
        :attachment
      )
    end

    def check_certificate_if_exists
      if audit_certificate.present?
        redirect_to users_form_answer_audit_certificate_url(form_answer),
                    notice: "Audit Certificate already completed!"
        return
      end
    end
end
