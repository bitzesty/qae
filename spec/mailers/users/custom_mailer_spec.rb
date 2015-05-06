require "rails_helper"

describe Users::CustomMailer do
  describe "#notify" do
    let(:body) do
      "Please visit https://google.com"
    end

    let(:subject) { "Custom subject" }
    let(:mail) { Users::CustomMailer.notify("user@example.com", body, subject) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq(["user@example.com"])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_link("https://google.com", href: "https://google.com")
      expect(mail.body.encoded).to match("Please visit")
    end
  end
end
