require "rails_helper"

describe MailRenderer do
  describe "#shortlisted_audit_certificate_reminder" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_audit_certificate_reminder
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Jane Doe")
      expect(rendered).to match("Enterprise promotion Award 2015")
    end
  end
end
