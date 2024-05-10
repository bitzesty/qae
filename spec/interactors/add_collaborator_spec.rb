require "rails_helper"

describe "Interactors::AddCollaborator" do
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

  let(:add_collaborator_interactor) do
    AddCollaborator.new(
      account_admin,
      account,
      create_params,)
  end

  describe "Add new user account and add him to Collaborators" do
    let(:new_user_email) { generate :email }
    let(:role) { "regular" }
    let(:create_params) do
      { email: new_user_email, role: role }
    end
    let(:new_regular_admin) do
      account.reload.users.last
    end

    it "should generate new User account without password and add person to collaborators" do
      expect {
        add_collaborator_interactor.run
      }.to change {
        User.count
      }.by(1)

      expect(account.reload.users.count).to be_eql 2
      expect(account.users.last.encrypted_password).to be_blank

      expect(new_regular_admin.email).to be_eql new_user_email
      expect(new_regular_admin.account_id).to be_eql account.id
      expect(new_regular_admin.role).to be_eql role
    end
  end

  describe "Attempt to add to Collaborators of existing user, which is belongs_to another Account" do
   let!(:existing_user_with_another_account_association) do
      FactoryBot.create :user, :completed_profile,
        first_name: "Another Account Admin Dave",
        role: "account_admin"
    end

   let(:existing_user_email) { existing_user_with_another_account_association.email }
   let(:role) { "regular" }
   let(:create_params) do
     { email: existing_user_email, role: role }
   end

   it "should not add existing user to collaborators as it already associated with another account" do
     expect { add_collaborator_interactor.run }
       .to not_change { account.reload.users.count }
       .and not_change { MailDeliveryWorker.jobs.size }

     expect(account.reload.users.count).to be_eql 1
     expect(add_collaborator_interactor.errors).to be_eql ["User already associated with another account!"]
   end
  end

  describe "Attempt to add user to Collaborators twice" do
    let!(:existing_collaborator) do
      FactoryBot.create :user, :completed_profile,
        first_name: "Collaborator Matt",
        account: account,
        role: "regular"
    end

    let(:existing_user_email) { existing_collaborator.email }
    let(:role) { "regular" }
    let(:create_params) {
      { email: existing_user_email, role: role }
    }

    it "should not add user to collaborators twice" do
      expect { add_collaborator_interactor.run }
        .to not_change { account.reload.users.count }
        .and not_change { MailDeliveryWorker.jobs.size }

      expect(account.reload.users.count).to be_eql 2
      expect(add_collaborator_interactor.errors).to be_eql ["This user already added to collaborators!"]
    end
  end
end
