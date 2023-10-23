class PdfAuditCertificates::Base < AuditCertificatePdf
  def award_type_short
    award_name = self.class.name.deconstantize.split("::").last.underscore
    I18n.t("pdf_texts.audit_certificates").dig(award_name.to_sym, :award_type_short) || award_name.titleize
  end

  private

  def initialize_form_answer(form)
    if notification = form.award_year.settings.email_notifications.where(kind: "shortlisted_notifier").order(:trigger_at).first
      form.paper_trail.version_at(notification.trigger_at).decorate
    else
      super
    end
  end
end
