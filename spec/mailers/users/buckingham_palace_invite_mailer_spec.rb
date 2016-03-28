require "rails_helper"

describe Users::BuckinghamPalaceInviteMailer do
  let(:palace_invite) { create :palace_invite, email: "palace@example.com" }
  let(:token) { palace_invite.token }

  describe "#notify" do
    let(:mail) { Users::BuckinghamPalaceInviteMailer.invite(palace_invite.id) }
    let(:account_holder) { palace_invite.form_answer.user }
    let(:account_holder_name) { "#{account_holder.title} #{account_holder.last_name}" }

    it "renders the headers" do
      expect(mail.to).to eq([palace_invite.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(account_holder_name)
      expect(mail.html_part.decoded).to have_link(
        "Log in here",
        href: dashboard_url
      )
    end
  end
end
