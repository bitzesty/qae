require "rails_helper"

describe AccountMailers::PromotionLettersOfSupportReminderMailer do
  let(:user) { create :user }
  let!(:award_year) { AwardYear.current }
  let(:form_answer) { create :form_answer, :promotion, user: user }

  let!(:settings) { create :settings, :submission_deadlines }

  let!(:deadline) do
    Settings.current_submission_deadline.trigger_at.strftime("%d/%m/%Y")
  end

  let(:mail) {
    AccountMailers::PromotionLettersOfSupportReminderMailer.notify(
      form_answer.id,
      user.id
    )
  }

  before do
    doc = form_answer.document
    form_answer.document = doc.merge(nominee_info_first_name: "Jovan",
                                     nominee_info_last_name: "Savovich")
    form_answer.save!
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(edit_form_url(id: form_answer.id))
      expect(mail.body.raw_source).to match(deadline)
      expect(mail.body.raw_source).to match("Jovan Savovich")
      expect(mail.body.raw_source).to match(user.decorate.full_name)
    end
  end
end
