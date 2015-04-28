require "rails_helper"

describe Users::PromotionLettersOfSupportReminderMailer do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, :promotion, user: user }

  let!(:settings) { create :settings, :submission_deadlines }

  let(:deadline) do
    Settings.current_submission_deadline.trigger_at.strftime("%d/%m/%Y")
  end

  before do
    doc = form_answer.document
    form_answer.document = doc.merge(nominee_info_first_name: "Jovan", nominee_info_last_name: "Savovich")
    form_answer.save!
  end

  describe "#notify" do
    let(:mail) { Users::PromotionLettersOfSupportReminderMailer.notify(form_answer.id) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(edit_form_url(id: form_answer.id))
      expect(mail.html_part.decoded).to match(deadline)
      expect(mail.html_part.decoded).to match("Jovan Savovich")
    end
  end
end
