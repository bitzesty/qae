require "rails_helper"

describe MailRenderer do
  describe "#shortlisted_audit_certificate_reminder" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_audit_certificate_reminder
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Jane Doe")
      expect(rendered).to match("Enterprise Promotion Award 2015")
    end
  end

  describe "#shortlisted_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#not_shortlisted_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.not_shortlisted_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#winners_press_release_comments_request" do
    it "renders e-mail" do
      rendered = described_class.new.winners_press_release_comments_request
      expect(rendered).to match("Jon Doe")
      link = "http://queens-awards-enterprise.service.gov.uk/users/form_answers/0/press_summary"
      expect(rendered).to match(link)
    end
  end

  describe "#all_unsuccessful_feedback" do
    it "renders e-mail" do
      rendered = described_class.new.all_unsuccessful_feedback
      expect(rendered).to match("Jon Doe")
    end
  end
end
