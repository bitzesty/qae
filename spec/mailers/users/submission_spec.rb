require "rails_helper"

describe Users::SubmissionMailer do
  let!(:user) { create :user }

  let(:form_answer) do
    FactoryBot.create :form_answer, :submitted, :innovation,
                                                 user: user
  end

  let(:urn) { form_answer.urn }
  let(:subject) { "Thank you for submitting your King’s Award Application! - Application ref #{form_answer.urn}" }

  before do
    form_answer
  end

  describe "Email Me" do
    let(:mail) { Users::SubmissionMailer.success(user.id, form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("[King's Awards for Enterprise] #{subject}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
      expect(mail.body.raw_source).to match(urn)
    end
  end
end
