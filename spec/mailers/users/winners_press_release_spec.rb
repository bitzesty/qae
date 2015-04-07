require "rails_helper"

describe Users::WinnersPressRelease do
  let!(:user) do
    FactoryGirl.create :user, :completed_profile,
                              first_name: "Admin John",
                              role: "account_admin"
  end

  describe "#notify" do
    let(:form_answer) do
      FactoryGirl.create :form_answer, :submitted, :innovation,
                                                   user: user,
                                                   document: { company_name: "Bitzesty" }
    end

    let!(:press_release) { create :press_summary, form_answer: form_answer }

    let(:mail) do
      Users::WinnersPressRelease.notify(form_answer.id)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("[Queen's Awards for Enterprise] Press Comment")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["info@queensawards.org.uk"])
    end

    it "renders the body" do
      url = users_form_answer_press_summary_url(form_answer, token: press_release.token)
      expect(mail.body.encoded).to match(user.decorate.full_name)
      expect(mail.body.encoded).to have_link("Review Press Comment",
                                             href: url)
    end
  end
end
