module AuditCertificateContext
  def show
    authorize form_answer, :download_audit_certificate_pdf?
    send_data resource.attachment.read,
              filename: resource.attachment.filename,
              disposition: "inline"
  end

  private

  def resource
    @audit_certificate ||= form_answer.audit_certificate
  end

  def form_answer
    @form_answer ||= @award_year.form_answers.find(params[:form_answer_id])
  end
end
