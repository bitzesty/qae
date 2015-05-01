require "rails_helper"

describe Users::NotifyNonShortlistedMailer do
  let!(:user) { create :user }
  let!(:form_answer) do
    create :form_answer, :submitted, :innovation, user: user
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) do
    "Queen's Awards for Enterprise: Thank you for applying"
  end

  describe "#notify" do
    let(:mail) { Users::NotifyNonShortlistedMailer.notify(form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(user.decorate.full_name)
    end
  end

  describe "#ep_notify" do
    let(:form_answer) { create :form_answer, :promotion, :submitted, user: user }
    let(:subject) do
      "Queen's Awards for Enterprise Promotion: Thank you for your nomination"
    end

    let(:mail) { Users::NotifyNonShortlistedMailer.ep_notify(form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(user.decorate.full_name)
    end
  end
end
