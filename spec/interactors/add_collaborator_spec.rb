require 'rails_helper'

describe "Interactors::AddCollaborator" do
  let!(:account_admin) do
    FactoryGirl.create :user, :completed_profile, 
                              first_name: "Account Admin John",
                              role: "account_admin"
  end

  let(:account) { account_admin: account }

  let!(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: account_admin,
                                     urn: "QA0001/19T",
                                     document: { company_name: "Bitzesty" }
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
    AddCollaborator.new(
      account_admin, 
      account, 
      create_params).run
  end

  describe "Add new user account and add him to Collaborators" do
    before do 

    end

    it "" do

    end
  end

  # describe "Add existing user to Collaborators" do
  #   before do 

  #   end
  #   it "" do
      
  #   end
  # end

  # describe "Attempt to add to Collaborators of existing user, which is belongs_to another Account" do
  #   before do 

  #   end
  #   it "" do
      
  #   end
  # end

  # describe "Attempt to add user to Collaborators twice" do
  #   before do 

  #   end
  #   it "" do
      
  #   end
  # end

  # describe "Remove user from Collaborators" do
  #   before do 

  #   end
  #   it "" do
      
  #   end
  # end
end
