require "rails_helper"

describe Account::CollaboratorsController, type: :controller do
  let(:user) { create :user, role: "account_admin" }
  let(:account) { user.account }

  describe "index" do
    it "updates collaborators checked at column" do
      sign_in user

      expect { get :index }.to(change do
        account.reload.collaborators_checked_at
      end)
    end
  end
end
