require "rails_helper"
include Warden::Test::Helpers

describe MailRenderer do
  describe "#submission_started_notification" do
    let(:login_link) do
      "http://www.kings-awards-enterprise.service.gov.uk/users/sign_in"
    end

    let(:user_full_name) do
      "Jon Doe"
    end

    let(:rendered_email) do
      described_class.new.submission_started_notification
    end

    it "renders e-mail" do
      expect(rendered_email).to match(user_full_name)
      expect(rendered_email).to match(login_link)
    end
  end

  describe "#shortlisted_audit_certificate_reminder" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_audit_certificate_reminder
      expect(rendered).to match("Jane Doe")
      # placeholder for date if deadlines are not set
      expect(rendered).to match(deadline_str)
    end
  end

  describe "#shortlisted_po_sd_reminder" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_po_sd_reminder
      expect(rendered).to match("Jane Doe")
      # placeholder for date if deadlines are not set
      expect(rendered).to match(deadline_str)
    end
  end

  describe "#shortlisted_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#shortlisted_po_sd_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_po_sd_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#shortlisted_po_sd_with_actual_figures_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.shortlisted_po_sd_with_actual_figures_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#not_shortlisted_notifier" do
    it "renders e-mail" do
      rendered = described_class.new.not_shortlisted_notifier
      expect(rendered).to match("Jon Doe")
    end
  end

  describe "#reminder_to_submit" do
    it "renders e-mail" do
      link = "http://www.kings-awards-enterprise.service.gov.uk/form/0"
      rendered = described_class.new.reminder_to_submit
      expect(rendered).to match(link)
    end
  end

  describe "#ep_reminder_support_letters" do
    it "renders e-mail" do
      link = "http://www.kings-awards-enterprise.service.gov.uk/form/0"
      rendered = described_class.new.ep_reminder_support_letters
      expect(rendered).to match("Jon Doe")
      expect(rendered).to match("Jane Doe")
      expect(rendered).to match(link)
      expect(rendered).to match(deadline_str)
    end
  end

  describe "#unsuccessful_notification" do
    it "renders e-mail" do
      rendered = described_class.new.unsuccessful_notification
      expect(rendered).to match("Mr Smith")
      expect(rendered).to match("QA0001/16I")
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
      expect(rendered).to match("Mr Smith")
      expect(rendered).to match(deadline_str("%A %d %B"))
    end
  end

  describe "#winners_head_of_organisation_notification" do
    it "renders e-mail" do
      rendered = described_class.new.winners_head_of_organisation_notification
      expect(rendered).to match("Congratulations! You have achieved a King's Award for Enterprise:")
    end
  end

  def deadline_str(format="%d/%m/%Y")
    DateTime.new(Date.current.year, 9, 21, 10, 30)
            .strftime(format)
  end
end
