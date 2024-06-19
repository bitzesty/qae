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
      kind: "buckingham_palace_reception_attendee_information_due_by",
    ).first
    attendees_info_due.update_column(:trigger_at,
      DateTime.new(Date.current.year, 5, 6, 00, 00),
    )

    settings.reload
  end

  let!(:form_answer) do
    fa = build(:form_answer, :awarded, :trade, user: user, award_year: year)

    allow(fa).to receive(:valid?).and_return(true)

    # this field is no longer used in 2019 awards, but we're using closed award year here
    # can be simplified when 2020 awards kick in
    fa.document["queen_award_holder"] = "no"
    fa.save!

    fa
  end

  let!(:palace_invite) do
    create :palace_invite, form_answer: form_answer, email: user.email
  end

  let(:account_holder) do
    user
  end

  let(:account_holder_name) do
    form_answer.decorate.head_of_business_full_name
  end

  let(:mail) do
    AccountMailers::BuckinghamPalaceInviteMailer.invite(
      form_answer.id,
    )
  end

  describe "#notify" do
    # it "renders the headers" do
    #   expect(mail.to).to eq([form_answer.decorate.head_email])
    #   expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    # end

    it "renders the body" do
      expect(mail.body.raw_source).to match(account_holder_name)
      expect(mail.body.raw_source).to include(edit_palace_invite_url(id: palace_invite.token))
    end
  end
end
