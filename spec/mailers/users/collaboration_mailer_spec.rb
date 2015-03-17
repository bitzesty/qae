require "rails_helper"

describe Users::CollaborationMailer do
  let!(:account_admin) do
    FactoryGirl.create :user, :completed_profile,
                              first_name: "Account Admin John",
                              role: "account_admin"
  end

  let(:account) { account_admin.account }

  describe "#access_granted" do
    describe "New user created and added to collaborators" do
      let!(:new_account_admin) do
        FactoryGirl.create :user, :completed_profile,
                                  first_name: "New Account Admin Mike",
                                  account: account,
                                  role: "account_admin"
      end

      let(:new_user) { true }
      let(:generated_password) { "strongpass" }
      let(:confirmation_token) { "12345678" }

      let(:mail) {
        Users::CollaborationMailer.access_granted(
          account_admin,
          new_account_admin,
          new_user,
          generated_password,
          confirmation_token
        )
      }

      let(:subject) { "#{account_admin.decorate.full_name} added you to collaborators!" }

      it "renders the headers" do
        expect(mail.subject).to eq("[Queen's Awards for Enterprise] #{subject}")
        expect(mail.to).to eq([new_account_admin.email])
        expect(mail.from).to eq(["info@queensawards.org.uk"])
      end

      it "renders the body" do
        expect(mail.body.encoded).to match(new_account_admin.role.humanize)
        expect(mail.body.encoded).to match(new_account_admin.email)
        expect(mail.body.encoded).to match(generated_password)
        expect(mail.body.encoded).to have_link("Confirm", href: user_confirmation_url(confirmation_token: confirmation_token))
      end
    end

    describe "Existing user added to collaborators" do
      let!(:new_account_admin) do
        FactoryGirl.create :user, :completed_profile,
                                  first_name: "New Account Admin Mike",
                                  account: account,
                                  role: "account_admin"
      end

      let(:new_user) { false }

      let(:mail) {
        Users::CollaborationMailer.access_granted(
          account_admin,
          new_account_admin,
          new_user
        )
      }

      let(:subject) { "#{account_admin.decorate.full_name} added you to collaborators!" }

      it "renders the headers" do
        expect(mail.subject).to eq("[Queen's Awards for Enterprise] #{subject}")
        expect(mail.to).to eq([new_account_admin.email])
        expect(mail.from).to eq(["info@queensawards.org.uk"])
      end

      it "renders the body" do
        expect(mail.body.encoded).to match(new_account_admin.role.humanize)
        expect(mail.body.encoded).to have_link("View", href: dashboard_url)
      end
    end
  end
end
