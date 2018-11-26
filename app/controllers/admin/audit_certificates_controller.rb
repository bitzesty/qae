class Admin::AuditCertificatesController < Admin::BaseController
  include AuditCertificateContext

  expose(:pdf_data) do
    form_answer.decorate.pdf_audit_certificate_generator
  end

  def download_initial_pdf
    authorize form_answer, :can_download_initial_audit_certificate_pdf?

    respond_to do |format|
      format.pdf do
        send_data pdf_data.render,
          filename: "audit_certificate_#{@form_answer.decorate.pdf_filename}",
          type: "application/pdf",
          disposition: 'attachment'
      end
    end
  end

  def create
    audit_certificate = form_answer.build_audit_certificate(audit_certificate_params)

    if saved = audit_certificate.save
      if form_answer.assessors.primary.present?
        Assessors::GeneralMailer.audit_certificate_uploaded(form_answer.id).deliver_later!
      end

      Users::AuditCertificateMailer.notify(form_answer.id, form_answer.user_id).deliver_later!
    end

    respond_to do |format|
      if saved
        format.html do
          redirect_to [namespace_name, form_answer]
        end

        format.js do
          render  partial: "admin/form_answers/docs/post_shortlisting_docs",
            locals: {
            resource: form_answer.decorate
          },
          content_type: "text/plain"
        end
      else
        format.html do
          redirect_to [namespace_name, form_answer],
            alert: audit_certificate.errors.full_messages.join(", ")
        end
        format.js do
          render json: audit_certificate,
            status: :created,
            content_type: "text/plain"
        end
      end
    end
  end

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
end
