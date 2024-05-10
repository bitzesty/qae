require "rails_helper"

describe Users::SubmissionStartedNotificationMailer do
  let(:user) { create(:user) }

  let(:subject) do
    "Notification: applications for International Trade Award are open"
  end

  let(:mail) do
    Users::SubmissionStartedNotificationMailer.notify(user.id, "trade")
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
      expect(mail.body.raw_source).to match(new_user_session_url)
    end
  end
end
