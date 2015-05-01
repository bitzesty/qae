require "rails_helper"

describe Users::ReminderToSubmitMailer do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, user: user }

  let!(:deadline) do
    d = Settings.current_submission_deadline
    d.update(trigger_at: Time.current)
    d.trigger_at.strftime("%d/%m/%Y")
  end

  describe "#notify" do
    let(:mail) { Users::ReminderToSubmitMailer.notify(form_answer.id) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(edit_form_url(id: form_answer.id))
      expect(mail.html_part.decoded).to match(deadline)
    end
  end
end
