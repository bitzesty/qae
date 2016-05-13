class Users::AuditCertificatesController < Users::BaseController

  before_action :check_if_audit_certificate_already_exist!, only: [:create]

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

    if saved = audit_certificate.save
      if form_answer.assessors.primary.present?
        Assessors::GeneralMailer.audit_certificate_uploaded(form_answer.id).deliver_later!
      end
    end

    respond_to do |format|
      format.html do
        if saved
          redirect_to users_form_answer_audit_certificate_url(form_answer),
                      notice: "Audit Certificate successfully uploaded!"
        else
          render :show
        end
      end

      format.json do
        if saved
          render json: audit_certificate,
                 status: :created,
                 content_type: "text/plain"
        else
          render json: { errors: humanized_errors }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def audit_certificate_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:audit_certificate].blank?
      params.merge!(
        audit_certificate: {
          attachment: ""
        }
      )
    end

    params.require(:audit_certificate).permit(:attachment)
  end

  def humanized_errors
    audit_certificate.errors
                     .full_messages
                     .reject { |m| m == "Attachment This field cannot be blank" }
                     .join(", ")
                     .delete("Attachment ")
  end

  def check_if_audit_certificate_already_exist!
    if audit_certificate.present? && audit_certificate.persisted?
      render nothing: true
      return
    end
  end
end
