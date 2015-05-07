require "rails_helper"

describe Users::CustomMailer do
  describe "#notify" do
    let(:body) do
      "Please visit https://google.com"
    end

    let(:user) { create(:user) }

    let(:subject) { "Custom subject" }
    let(:mail) { Users::CustomMailer.notify(user.id, "User", body, subject) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_link("https://google.com", href: "https://google.com")
      expect(mail.body.encoded).to match("Please visit")
      expect(mail.body.encoded).to match(user.decorate.full_name)
    end
  end
end
