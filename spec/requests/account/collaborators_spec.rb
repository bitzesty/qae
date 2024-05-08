require "rails_helper"
include Warden::Test::Helpers

describe "API" do
  let!(:account_admin) do
    FactoryBot.create :user, :completed_profile,
      first_name: "Account Admin John",
      role: "account_admin"
  end

  let(:account) { account_admin.account }

  let!(:form_answer) do
    FactoryBot.create :form_answer, :innovation,
      user: account_admin,
      urn: "QA0001/19T",
      document: { company_name: "Bitzesty" }
  end

  let!(:basic_eligibility) do
    FactoryBot.create :basic_eligibility, form_answer: form_answer,
      account: account
  end

  let!(:innovation_eligibility) do
    FactoryBot.create :innovation_eligibility, form_answer: form_answer,
      account: account
  end

  let!(:trade_eligibility) do
    FactoryBot.create :trade_eligibility, form_answer: form_answer,
      account: account
  end

  let!(:development_eligibility) do
    FactoryBot.create :development_eligibility, form_answer: form_answer,
      account: account
  end


  before do
    login_as account_admin
  end

  describe "GET /account/collaborators" do
    before do
      get account_collaborators_path
    end

    it do
      expect(response.status).to eq(200)
    end
  end

  describe "GET /account/collaborators/new" do
    before do
      get new_account_collaborator_path, xhr: true
    end

    it do
      expect(response.status).to eq(200)
    end
  end

  describe "POST /account/collaborators" do
    let(:new_user_email) { generate :email }
    let(:role) { "regular" }
    let(:create_params) {
      { email: new_user_email, role: role }
    }
    let(:new_regular_admin) {
      account.reload.users.last
    }

    before do
      post account_collaborators_path, params: { collaborator: create_params }, xhr: true
    end

    it "should generate new user without password and add him to collaborators" do
      expect(User.count).to be_eql 2
      expect(account.reload.users.count).to be_eql 2
      expect(account.users.last.encrypted_password).to be_empty

      expect(new_regular_admin.email).to be_eql new_user_email
      expect(new_regular_admin.account_id).to be_eql account.id
      expect(new_regular_admin.role).to be_eql role
    end
  end

  describe "DELETE /account/collaborators/:id" do
    let!(:existing_collaborator) do
      FactoryBot.create :user, :completed_profile,
        first_name: "Collaborator Matt",
        account: account,
        role: "regular"
    end

    let!(:another_account_admin) do
      create :user,
        :completed_profile,
        first_name: "Another Account Admin Mike",
        account: account,
        role: "account_admin"
    end

    it "should remove user from collaborators, but do not remove user account" do
      expect {
        delete account_collaborator_path(existing_collaborator), xhr: true
      }.to not_change { MailDeliveryWorker.jobs.size }

      expect(User.count).to be_eql 3
      expect(account.reload.users.count).to be_eql 2
    end
  end
end
