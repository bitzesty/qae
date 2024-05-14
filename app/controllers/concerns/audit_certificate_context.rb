module AuditCertificateContext
  def show
    authorize form_answer, :download_audit_certificate_pdf?
    redirect_to resource.attachment_url, allow_other_host: true
  end

  def create
    authorize form_answer, :create_audit_certificate_pdf?

    audit_certificate = form_answer.build_audit_certificate(audit_certificate_params)

    if (saved = audit_certificate.save)
      log_event

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
          render partial: "admin/form_answers/docs/post_shortlisting_docs",
            locals: {
              resource: form_answer.decorate,
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

  private

  def action_type
    case action_name
    when "create"
      "audit_certificate_uploaded"
    else
      raise "Attempted to log an unsupported action (#{action_name})"
    end
  end

  def resource
    @audit_certificate ||= form_answer.audit_certificate
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def audit_certificate_params
    # This is fix of "missing 'audit_certificate' param"
    # if no any was selected in file input
    if params[:audit_certificate].blank?
      params.merge!(
        audit_certificate: {
          attachment: "",
        },
      )
    end

    params.require(:audit_certificate).permit(:attachment)
  end
end
