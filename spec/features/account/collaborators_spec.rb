require 'rails_helper'
include Warden::Test::Helpers

describe "Collaborators", %q{
As a Account Admin
I want to be able to add / remove collaborators to Account
So that they can collaborate form answers
} do

  let!(:account_admin) do
    FactoryGirl.create :user, :completed_profile, 
                              first_name: "Account Admin John",
                              role: "account_admin"
  end

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: account_admin,
                                     urn: "QA0001/19T",
                                     document: { company_name: "Bitzesty" }
  end

  let!(:basic_eligibility) do
    FactoryGirl.create :basic_eligibility, form_answer: form_answer,
                                           user: account_admin
  end

  let!(:innovation_eligibility) do
    FactoryGirl.create :innovation_eligibility, form_answer: form_answer,
                                                user: account_admin
  end

  let!(:trade_eligibility) do
    FactoryGirl.create :trade_eligibility, form_answer: form_answer,
                                           user: account_admin
  end

  let!(:development_eligibility) do
    FactoryGirl.create :development_eligibility, form_answer: form_answer,
                                                 user: account_admin
  end

  let!(:another_account_admin) do
    FactoryGirl.create :user, :completed_profile, 
                              first_name: "Another Account Admin Mike",
                              account: account_admin.account,
                              role: "account_admin"
  end

  let!(:regular_admin) do
    FactoryGirl.create :user, :completed_profile, 
                              first_name: "Regular Admin Kelly",
                              account: account_admin.account,
                              role: "regular"
  end

  before do
    login_as account_admin
    visit account_collaborators_path
  end

  describe "List of Collaborators" do
    it "Should see list of account collaborators, excluding his self" do
      expect_to_see "Collaborators"

      within(".js-collaborators-list") do
        expect_to_see another_account_admin.decorate.full_name
        expect_to_see regular_admin.decorate.full_name
        expect_to_see_no account_admin.decorate.full_name
      end
    end
  end

  # OTHER ADD / REMOVE COLLABORATOR INTERACTIONS ARE COVERED IN 
  # spec/interactors/add_collaborator_spec.rb
end
