require "rails_helper"

describe RescanService do
  describe ".perform" do
    it "triggers rescan on attachment models" do
      expect(described_class).to receive(:rescan_model).with(SupportLetterAttachment, :attachment)
      expect(described_class).to receive(:rescan_model).with(FormAnswerAttachment, :file)
      expect(described_class).to receive(:rescan_model).with(AuditCertificate, :attachment)
      described_class.perform
    end
  end

  describe ".rescan_model" do
    let!(:form_answer) { create(:form_answer) }
    let!(:audit_certificate) { create(:audit_certificate, form_answer:) }

    it "rescans unresolved files" do
      audit_certificate.attachment_scan_results = "scanning"
      audit_certificate.save!

      expect_any_instance_of(AuditCertificate).to receive(:scan_attachment!)

      described_class.rescan_model(AuditCertificate, :attachment)
    end

    it "does not rescan clean files" do
      audit_certificate.attachment_scan_results = "clean"
      audit_certificate.save!

      expect_any_instance_of(AuditCertificate).not_to receive(:scan_attachment!)

      described_class.rescan_model(AuditCertificate, :attachment)
    end
  end
end
