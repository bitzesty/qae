require "rails_helper"

describe Users::ShortlistedUnsuccessfulFeedbackMailer do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, user: user }

  before do
    form_answer.update_column(:company_or_nominee_name, "Bit Zesty")
  end

  describe "#notify" do
    let(:mail) { Users::ShortlistedUnsuccessfulFeedbackMailer.notify(form_answer.id) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to have_link("You can view your application feedback here.", href: "#")
      expect(mail.html_part.decoded).to match("Bit Zesty")
    end
  end
end
