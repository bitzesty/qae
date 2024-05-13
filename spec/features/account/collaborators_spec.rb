require "rails_helper"
include Warden::Test::Helpers
include ActiveJob::TestHelper

describe "Collaborators", %q{
As a Account Admin
I want to be able to add / remove collaborators to Account
So that they can collaborate form answers
} do
  let!(:account_admin) do
    create :user,
      :completed_profile,
      first_name: "Account Admin John",
      role: "account_admin"
  end

  let!(:account) { account_admin.account }

  let!(:form_answer) do
    create :form_answer,
      :innovation,
      user: account_admin,
      urn: "QA0001/19T",
      document: { company_name: "Bitzesty" }
  end

  let!(:basic_eligibility) do
    create :basic_eligibility,
      form_answer: form_answer,
      account: account
  end

  let!(:innovation_eligibility) do
    create :innovation_eligibility,
      form_answer: form_answer,
      account: account
  end

  let!(:trade_eligibility) do
    create :trade_eligibility,
      form_answer: form_answer,
      account: account
  end

  let!(:development_eligibility) do
    create :development_eligibility,
      form_answer: form_answer,
      account: account
  end

  let!(:another_account_admin) do
    create :user,
      :completed_profile,
      first_name: "Another Account Admin Mike",
      account: account,
      role: "account_admin"
  end

  let!(:regular_user) do
    create :user,
      :completed_profile,
      first_name: "Regular User Kelly",
      account: account,
      role: "regular"
  end

  describe "Permissions" do
    describe "Access to Collaborators section" do
      describe "I'm logged in as account admin and I can see the List of Collaborators" do
        before do
          login_as account_admin
          visit account_collaborators_path
        end

        it "Should see list of account collaborators, and themself" do
          expect_to_see "Collaborators and account owner"

          within(".collaborators-list") do
            expect_to_see another_account_admin.decorate.full_name
            expect_to_see regular_user.decorate.full_name
            expect_to_see account_admin.decorate.full_name
          end
        end
      end

      describe "Add new Collaborator" do
        before do
          login_as account_admin
          visit new_account_collaborator_path
        end

        describe "Invalid Attempts" do
          it "can't add person without email" do
            within("#new_collaborator") do
              expect {
                click_on "Add the collaborator"
              }.to_not change {
                account.reload.users.count
              }
            end

            within(".collaborator_email") do
              expect_to_see "Email is empty - it is a required field and must be filled in"
            end
          end

          it "can't add person with invalid email" do
            within("#new_collaborator") do
              fill_in "Email", with: "12345678"
              choose("Collaborator only")

              expect {
                click_on "Add the collaborator"
              }.to_not change {
                account.reload.users.count
              }
            end

            within(".collaborator_email") do
              expect_to_see "is invalid"
            end
          end

          describe "Attempt to add person, which is already associated with another account" do
            let!(:user_associated_with_another_account) do
              create :user,
                :completed_profile,
                role: "account_admin"
            end

            it "can't add" do
              within("#new_collaborator") do
                fill_in "Email", with: user_associated_with_another_account.email
                choose("Admin and collaborator")

                expect {
                  click_on "Add the collaborator"
                }.to_not change {
                  account.reload.users.count
                }
              end

              expect_to_see "User already associated with another account!"
            end
          end

          describe "Attempt to add person, which is already in collaborators" do
            it "can't add" do
              within("#new_collaborator") do
                fill_in "Email", with: account_admin.email
                choose("Admin and collaborator")

                expect {
                  click_on "Add the collaborator"
                }.to_not change {
                  account.reload.users.count
                }
              end

              expect_to_see "This user already added to collaborators!"
            end
          end
        end

        describe "Success Add to Collaborators" do
          describe "Adding of new user record" do
            let(:new_user_email) { "abcdyfg@example.com" }

            it "should create new user record with regular role" do
              within("#new_collaborator") do
                fill_in "Email", with: new_user_email
                choose("Collaborator only")

                expect {
                  click_on "Add the collaborator"
                }.to change {
                  account.reload.users.count
                }.by(1)
              end

              new_user = User.last
              expect(new_user.email).to be_eql new_user_email
              expect(new_user.role).to be_eql "regular"

              expect_to_see "#{new_user_email} successfully added to Collaborators!"
            end
          end
        end
      end

      describe "Remove from Collaborators" do
        let!(:collaborator) do
          create :user,
            :completed_profile,
            account_id: account.id,
            role: "regular"
        end

        before do
          login_as account_admin
          visit account_collaborators_path
        end

        it "should remove user from Collaborators, but do not remove User record" do
          within(".collaborators-list #user_#{collaborator.id}") do
            expect_to_see collaborator.email
            click_on "Edit details"
          end

          expect {
            click_link "js-remove-collaborator-link"
          }.to change {
            account.reload.users.count
          }.by(-1)

          collaborator.reload
          expect(collaborator.account_id).not_to eq(account_admin.account.id)
          expect(collaborator.role).to eq("account_admin")

          expect_to_see "#{collaborator.email} successfully removed from Collaborators!"
        end

        it "should redirect to an confirmation page if the only collaborator" do
          regular_user.delete
          another_account_admin.delete

          within(".collaborators-list #user_#{collaborator.id}") do
            expect_to_see collaborator.email
            click_on "Edit details"
          end

          click_link "Remove collaborator"
          expect_to_see "Are you sure you want remove this collaborator?"

          expect {
            click_link "Yes, remove collaborator"
          }.to change {
            account.reload.users.count
          }.by(-1)
        end
      end

      describe "I'm logged in as regular user and I can access the Collaborators section" do
        before do
          login_as regular_user
        end

        it "Should not restrict access for non account admins to collaborators page" do
          visit account_collaborators_path

          expect_to_see "Collaborators"
          expect(current_path).to be_eql(account_collaborators_path)
        end

        it "should restrict access for non account admins new collaborators page" do
          visit new_account_collaborator_path

          expect_to_see "Access denied!"
          expect(current_path).to be_eql(dashboard_path)
        end
      end
    end
  end

  def submit_new_collaborator_form
    within("#new_collaborator") do
      click_button "Add"
    end
  end
end
