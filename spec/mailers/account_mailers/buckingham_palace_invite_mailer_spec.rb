require "rails_helper"

describe AccountMailers::BuckinghamPalaceInviteMailer do
  let!(:user) { create :user }

  let!(:year) do
    create(:award_year)
  end
  let!(:year_settings) do
    settings = year.settings

    invite = settings.deadlines.where(kind: "buckingham_palace_attendees_invite").first
    invite.update_column(:trigger_at, DateTime.new(Date.current.year, 7, 14, 18, 00))

    attendees_info_due = settings.deadlines.where(
      kind: "buckingham_palace_reception_attendee_information_due_by"
    ).first
    attendees_info_due.update_column(:trigger_at,
      DateTime.new(Date.current.year, 5, 6, 00, 00)
    )

    settings.reload
  end

  let!(:form_answer) do
    create :form_answer, :awarded, :innovation, user: user, award_year: year
  end
  let(:palace_invite) do
    create :palace_invite, form_answer: form_answer, email: user.email
  end

  let(:account_holder) do
    user
  end
  let(:account_holder_name) do
    "#{account_holder.title} #{account_holder.last_name}"
  end

  let(:mail) do
    AccountMailers::BuckinghamPalaceInviteMailer.invite(
      palace_invite.id,
      account_holder.id
    )
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([account_holder.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(account_holder_name)
      expect(mail.html_part.decoded).to have_link(
        "log in here",
        href: dashboard_url
      )
    end
  end
end
