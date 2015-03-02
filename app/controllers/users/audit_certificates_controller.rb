class Users::AuditCertificatesController < Users::BaseController
  before_action :check_certificate_if_exists, only: [:create]

  expose(:form_answer) {
    current_user.account
                .form_answers
                .find(params[:form_answer_id])
  }

  expose(:csv_data) {
    AuditCertificateCsvGenerator.new(form_answer)
                                .run
  }

  expose(:audit_certificate) {
    form_answer.audit_certificate
  }

  def show
    respond_to do |format|
      format.html
      format.csv do
        send_data(
          csv_data,
          filename: "audit_certificate_#{form_answer.decorate.csv_filename}",
          type: "application/csv"
        )
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
      params.merge!({audit_certificate: {attachment: ''}}) if params[:audit_certificate].blank?

      params.require(:audit_certificate).permit(
        :attachment
      )
    end

    def check_certificate_if_exists
      if audit_certificate.present?
        redirect_to :back, notice: "Audit Certificate already completed!"
      end
    end
end
