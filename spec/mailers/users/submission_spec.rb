require "rails_helper"

describe Users::SubmissionMailer do
  let!(:user) { create :user }

  let(:form_answer) do
    FactoryGirl.create :form_answer, :submitted, :innovation,
                                                 user: user
  end

  let(:urn) { form_answer.urn }
  let(:subject) { "submission successfully created!" }

  before do
    form_answer
  end

  describe "Email Me" do
    let(:mail) { Users::SubmissionMailer.success(user.id, form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("[Queen's Awards for Enterprise] #{subject}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to match(user.decorate.full_name)
      expect(mail.html_part.decoded).to match(urn)
    end
  end
end
