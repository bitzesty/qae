require "rails_helper"

describe MailRenderer do
  describe "#shortlisted_audit_certificate_reminder" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_audit_certificate_reminder
      expect(rendered).to match("Jane Doe")
      # placeholder for date if deadlines are not set
      expect(rendered).to match("21/09/#{Date.current.year}")
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

  describe "#reminder_to_submit" do
    it "renders e-mail" do
      link = "http://queens-awards-enterprise.service.gov.uk/form/0"
      rendered = described_class.new.reminder_to_submit
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match(link)
      expect(rendered).to match("21/09/#{Date.current.year}")
    end
  end

  describe "#ep_reminder_support_letters" do
    it "renders e-mail" do
      link = "http://queens-awards-enterprise.service.gov.uk/form/0"
      rendered = described_class.new.ep_reminder_support_letters
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Jane Doe")
      expect(rendered).to match(link)
      expect(rendered).to match("21/09/#{Date.current.year}")
    end
  end

  describe "#unsuccessful_notification" do
    it "renders e-mail" do
      rendered = described_class.new.unsuccessful_notification
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Company Name")
    end
  end

  describe "#unsuccessful_ep_notification" do
    it "renders e-mail" do
      rendered = described_class.new.unsuccessful_ep_notification
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Nominee Name")
    end
  end

  describe "#winners_notification" do
    it "renders e-mail" do
      rendered = described_class.new.winners_notification
      expect(rendered).to match("Jon Snow")
      expect(rendered).to match("21/09/#{Date.current.year}")
    end
  end
end
