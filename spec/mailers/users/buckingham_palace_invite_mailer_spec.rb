require "rails_helper"

describe Users::BuckinghamPalaceInviteMailer do
  let(:palace_invite) { create :palace_invite, email: "palace@example.com" }

  let!(:settings) { create :settings, :submission_deadlines }

  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "buckingham_palace_attendees_details").first
    deadline.update(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  describe "#notify" do
    let(:mail) { Users::BuckinghamPalaceInviteMailer.invite(palace_invite.id) }

    before do
      allow_any_instance_of(FormAnswer).to receive(:head_of_business) { "Jon Snow" }
    end

    it "renders the headers" do
      expect(mail.to).to eq([palace_invite.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to have_link("Log in here",
                                                  href: dashboard_url)
      expect(mail.html_part.decoded).to match("Jon Snow")
    end
  end
end
