require "rails_helper"

describe AccountMailers::NotifyNonShortlistedMailer do
  let!(:user) { create :user }
  let!(:form_answer) do
    create :form_answer, :submitted, :innovation, user: user
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) do
    "King's Awards for Enterprise: Thank you for applying - Application ref #{form_answer.urn}"
  end

  describe "#notify" do
    let(:mail) {
      AccountMailers::NotifyNonShortlistedMailer.notify(
        form_answer.id,
        user.id,
      )
    }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
    end
  end
end
