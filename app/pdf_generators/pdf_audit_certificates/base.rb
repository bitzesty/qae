class PdfAuditCertificates::Base < AuditCertificatePdf
  private

  def initialize_financial_pointer
    if notification = form_answer.award_year.settings.email_notifications.where(kind: "shortlisted_notifier").order(:trigger_at).first
      @financial_pointer = FormFinancialPointer.new(form_answer.version_at(notification.trigger_at).decorate, {
        exclude_ignored_questions: true,
        financial_summary_view: true
      })
    else
      super
    end
  end
end
