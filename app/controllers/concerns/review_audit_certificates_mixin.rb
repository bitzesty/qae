module ReviewAuditCertificatesMixin
  def create
    @review_audit_certificate = ReviewAuditCertificate.new(create_params)
    @review_audit_certificate.subject = current_subject

    authorize @review_audit_certificate, :create?

    @review_audit_certificate.save

    respond_to do |format|
      format.js { head :ok }
      format.html do
        redirect_to [namespace_name, @review_audit_certificate.form_answer]
      end
    end
  end

  private

  def create_params
    params.require(:review_audit_certificate).permit(
      :changes_description,
      :form_answer_id,
      :status,
    )
  end
end
