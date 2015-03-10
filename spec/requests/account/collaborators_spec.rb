require 'rails_helper'
include Warden::Test::Helpers

describe 'API' do
  include ActiveJob::TestHelper

  let!(:account_admin) do
    FactoryGirl.create :user, :completed_profile,
                              first_name: "Account Admin John",
                              role: "account_admin"
  end

  let(:account) { account_admin.account }

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: account_admin,
                                     urn: "QA0001/19T",
                                     document: { company_name: "Bitzesty" }
  end

  let!(:basic_eligibility) do
    FactoryGirl.create :basic_eligibility, form_answer: form_answer,
                                           account: account
  end

  let!(:innovation_eligibility) do
    FactoryGirl.create :innovation_eligibility, form_answer: form_answer,
                                                account: account
  end

  let!(:trade_eligibility) do
    FactoryGirl.create :trade_eligibility, form_answer: form_answer,
                                           account: account
  end

  let!(:development_eligibility) do
    FactoryGirl.create :development_eligibility, form_answer: form_answer,
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
      xhr :get, new_account_collaborator_path
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
      clear_enqueued_jobs
      xhr :post, account_collaborators_path, collaborator: create_params
    end

    it "should generate new user, add him to collaborators and send him welcome email" do
      expect(User.count).to be_eql 2
      expect(account.reload.users.count).to be_eql 2

      expect(new_regular_admin.email).to be_eql new_user_email
      expect(new_regular_admin.account_id).to be_eql account.id
      expect(new_regular_admin.role).to be_eql role

      expect(enqueued_jobs.size).to be_eql(1)
    end
  end

  describe "DELETE /account/collaborators/:id" do
    let!(:existing_collaborator) do
      FactoryGirl.create :user, :completed_profile,
                                first_name: "Collaborator Matt",
                                account: account,
                                role: "regular"
    end

    before do
      clear_enqueued_jobs
      xhr :delete, account_collaborator_path(existing_collaborator)
    end

    it "should remove user from collaborators, but do not remove user account" do
      expect(User.count).to be_eql 2
      expect(account.reload.users.count).to be_eql 1

      expect(enqueued_jobs.size).to be_eql(0)
    end
  end
end
