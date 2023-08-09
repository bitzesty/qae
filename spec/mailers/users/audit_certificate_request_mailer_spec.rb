require "rails_helper"

describe Users::AuditCertificateRequestMailer do
  let!(:user) { create :user }
  let(:form_answer) do
    create :form_answer, :submitted, :innovation, user: user
  end

  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    deadline.update(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) {
    "King's Awards for Enterprise: Reminder to provide verification of commercial figures - Application ref #{form_answer.urn}"
  }

  before do
    form_answer
  end

  describe "#notify" do
    let(:mail) { described_class.notify(form_answer.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
      expect(mail.body.raw_source).to match(users_form_answer_audit_certificate_url(form_answer))
      expect(mail.body.raw_source).to match(deadline)
    end
  end
end
