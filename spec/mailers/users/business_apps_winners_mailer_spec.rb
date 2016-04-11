require "rails_helper"

describe Users::BusinessAppsWinnersMailer do
  let!(:form_answer) do
    create :form_answer, :awarded, :innovation
  end

  let!(:settings) { create :settings, :submission_deadlines }

  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "buckingham_palace_attendees_details").first
    deadline.update(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  describe "#notify" do
    let(:mail) { Users::BusinessAppsWinnersMailer.notify(form_answer.id) }
    let(:account_holder) { form_answer.user }
    let(:account_holder_name) { "#{account_holder.title} #{account_holder.last_name}" }

    it "renders the headers" do
      expect(mail.to).to eq([account_holder.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      expect(mail.html_part.decoded).to have_link("Log in here",
                                                  href: dashboard_url)
      expect(mail.html_part.decoded).to match(account_holder_name)
    end
  end
end
