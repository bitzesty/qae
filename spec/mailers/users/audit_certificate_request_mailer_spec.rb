require "rails_helper"

describe Users::AuditCertificateRequestMailer do
  let!(:user) { create :user }
  let(:form_answer) do
    create :form_answer, :submitted, :innovation,
                                                 user: user,
                                                 document: { company_name: "Bitzesty" }

  end
  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) {
    "[Queen's Awards] #{award_title} request to complete an audit certificate!"
  }

  before do
    allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
    form_answer
  end

  describe "#notify" do
    let(:mail) { Users::AuditCertificateRequestMailer.notify(user.id, form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@queensawards.org.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.decorate.full_name)
      expect(mail.body.encoded).to match(award_title)
      expect(mail.body.encoded).to have_link("Review Audit Certificate", href: users_form_answer_audit_certificate_url(form_answer))
    end
  end
end
