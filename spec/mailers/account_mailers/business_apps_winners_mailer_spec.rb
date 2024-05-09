require "rails_helper"

describe AccountMailers::BusinessAppsWinnersMailer do
  let!(:form_answer) do
    create :form_answer, :awarded, :innovation
  end

  let!(:settings) { create :settings, :submission_deadlines }
  let(:account_holder) { form_answer.user }
  let(:account_holder_name) { "#{account_holder.title} #{account_holder.last_name}" }

  let(:mail) {
    AccountMailers::BusinessAppsWinnersMailer.notify(
      form_answer.id,
      account_holder.id,
    )
  }

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([account_holder.email])
      expect(mail.from).to eq(["no-reply@kings-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(dashboard_url)
      expect(mail.body.raw_source).to match(account_holder_name)
    end
  end
end
