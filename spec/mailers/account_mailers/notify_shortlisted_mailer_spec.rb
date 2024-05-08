require "rails_helper"

describe AccountMailers::NotifyShortlistedMailer do
  let!(:user) { create :user }
  let!(:collaborator) { create :user, account: user.account, role: "regular" }


  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    deadline.update(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) do
    "King's Awards for Enterprise: Congratulations, you've been shortlisted."
  end

  describe "#notify" do
    let!(:form_answer) do
      create :form_answer, :submitted, :innovation, user: user
    end

    let(:mail) do
      described_class.notify(
        form_answer.id,
        user.id,
      )
    end

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
      expect(mail.body.raw_source).to match(deadline)
    end
  end

  describe "#notify_po_sd" do
    let!(:form_answer) do
      create :form_answer, :submitted, :mobility, user: user
    end

    let(:mail) do
      described_class.notify_po_sd(
        form_answer.id,
        user.id,
      )
    end

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
      expect(mail.body.raw_source).to match(deadline)
    end
  end
end
