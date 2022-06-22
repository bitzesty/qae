require "rails_helper"

describe AccountMailers::NotifyShortlistedVocfFreeMailer do
  let!(:user) { create :user }
  let!(:collaborator) { create :user, account: user.account, role: "regular" }

  let(:form_answer) do
    create :form_answer, :submitted, :innovation, user: user
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) do
    "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"
  end

  let(:mail) {
    AccountMailers::NotifyShortlistedVocfFreeMailer.notify(
      form_answer.id,
      user.id
    )
  }

  before do
    form_answer
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
    end
  end
end
