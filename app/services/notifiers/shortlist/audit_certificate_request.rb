class Notifiers::Shortlist::AuditCertificateRequest < Notifiers::AccountNotifier
  def initialize(form_answer)
    @form_answer = form_answer
    @account = form_answer.account
  end

  def run
    recipients.each do |recipient|
      Users::AuditCertificateRequestMailer.notify(recipient.id, form_answer.id).deliver_later!
    end
  end
end
