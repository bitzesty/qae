module AuditCertificateContext
  def show
    authorize form_answer, :download_audit_certificate_pdf?
    redirect_to resource.attachment_url
  end

  private

  def resource
    @audit_certificate ||= form_answer.audit_certificate
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end
end
