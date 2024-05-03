require "rails_helper"
include Warden::Test::Helpers

describe "API" do
  include ActiveJob::TestHelper

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
    FactoryBot.create :basic_eligibility, form_answer:,
                                          account:
  end

  let!(:innovation_eligibility) do
    FactoryBot.create :innovation_eligibility, form_answer:,
                                               account:
  end

  let!(:trade_eligibility) do
    FactoryBot.create :trade_eligibility, form_answer:,
                                          account:
  end

  let!(:development_eligibility) do
    FactoryBot.create :development_eligibility, form_answer:,
                                                account:
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
    let(:create_params) do
      { email: new_user_email, role: }
    end
    let(:new_regular_admin) do
      account.reload.users.last
    end

    before do
      clear_enqueued_jobs
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
                        account:,
                        role: "regular"
    end

    let!(:another_account_admin) do
      create :user,
             :completed_profile,
             first_name: "Another Account Admin Mike",
             account:,
             role: "account_admin"
    end

    before do
      clear_enqueued_jobs
      delete account_collaborator_path(existing_collaborator), xhr: true
    end

    it "should remove user from collaborators, but do not remove user account" do
      expect(User.count).to be_eql 3
      expect(account.reload.users.count).to be_eql 2

      expect(enqueued_jobs.size).to be_eql(0)
    end
  end
end
