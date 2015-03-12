require "rails_helper"

describe Notifiers::EmailNotificationService do
  let!(:sent_notification) { create(:email_notification, trigger_at: Time.now - 1.day, sent: true, kind: "shortlisted_audit_certificate_reminder") }
  let!(:current_notification) { create(:email_notification, trigger_at: Time.now - 1.day, kind: "shortlisted_audit_certificate_reminder") }
  let!(:future_notification) { create(:email_notification, trigger_at: Time.now + 1.day, kind: "shortlisted_audit_certificate_reminder") }
  let(:form_answer) { create(:form_answer, :submitted) }

  it "triggers current notification" do
    allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }

    service = double
    expect(service).to receive(:run)
    expect(Notifiers::Shortlist::AuditCertificateRequest).to receive(:new).with(form_answer) { service }

    expect(FormAnswer).to receive(:shortlisted_with_no_certificate) { [form_answer] }

    described_class.run

    expect(current_notification.reload).to be_sent
  end
end
