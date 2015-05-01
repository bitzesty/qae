require "rails_helper"

describe Users::WinnersPressRelease do
  let!(:user) do
    FactoryGirl.create :user, :completed_profile,
                              first_name: "Admin John",
                              role: "account_admin"
  end

  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "press_release_comments").first
    deadline.update!(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  describe "#notify" do
    let(:form_answer) do
      FactoryGirl.create :form_answer, :submitted, :innovation,
                                                   user: user
    end

    let!(:press_release) { create :press_summary, form_answer: form_answer }

    let(:mail) do
      Users::WinnersPressRelease.notify(form_answer.id)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("[Queen's Awards for Enterprise] Press Comment")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@queens-awards-enterprise.service.gov.uk"])
    end

    it "renders the body" do
      url = users_form_answer_press_summary_url(form_answer, token: press_release.token)
      expect(mail.body.encoded).to match(user.decorate.full_name)
      expect(mail.body.encoded).to have_link("Check your Press book piece.",
                                             href: url)
    end
  end
end
