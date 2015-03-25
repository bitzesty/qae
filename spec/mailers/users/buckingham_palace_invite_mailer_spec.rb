require "rails_helper"

describe Users::BuckinghamPalaceInviteMailer do
  let(:palace_invite) { create :palace_invite, email: "palace@example.com" }

  before do
    allow_any_instance_of(FormAnswer).to receive(:eligible?) { true }
  end

  describe "#notify" do
    let(:mail) { Users::BuckinghamPalaceInviteMailer.invite(palace_invite.id) }

    it "renders the headers" do
      expect(mail.to).to eq([palace_invite.email])
      expect(mail.from).to eq(["info@queensawards.org.uk"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_link("attendee details",
                                             href: edit_palace_invite_url(id: palace_invite.token))
    end
  end
end
