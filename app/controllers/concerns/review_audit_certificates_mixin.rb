module ReviewAuditCertificatesMixin

  def self.included(base)
    base.before_action :form_answer
  end

  def create
    @review_audit_certificate = ReviewAuditCertificate.new(create_params)
    @review_audit_certificate.subject = current_subject
    
    authorize @review_audit_certificate, :create?

    log_event if @review_audit_certificate.save

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
      :status
    )
  end

  def form_answer
    form_answer = FormAnswer.find(params[:review_audit_certificate][:form_answer_id])
  end

  def action_type
    "verification_of_commercial_figures_#{action_name}"
  end
end
