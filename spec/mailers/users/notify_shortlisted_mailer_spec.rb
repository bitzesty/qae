require "rails_helper"

describe Users::NotifyShortlistedMailer do
  let!(:user) { create :user }
  let!(:collaborator) { create :user, account: user.account, role: "regular" }

  let(:form_answer) do
    create :form_answer, :submitted, :innovation, user: user
  end

  let!(:deadline) do
    # deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    # deadline.update(trigger_at: Date.current)
    # deadline.trigger_at.strftime("%d/%m/%Y")
    #
    # for now deadline is harcoded
    Date.new(2015, 12, 17).strftime("%d/%m/%Y")
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) do
    "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"
  end

  before do
    form_answer
  end

  describe "#notify" do
    let(:mail) { Users::NotifyShortlistedMailer.notify(form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.bcc).to eq(user.account.collaborators_without(user).map(&:email))
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(user.decorate.full_name)
      expect(mail.html_part.decoded).to have_link("log in now", href: new_user_session_url)
      expect(mail.html_part.decoded).to match(deadline)
    end
  end
end
