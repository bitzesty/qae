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
          disposition: "attachment"
      end
    end
  end

end
