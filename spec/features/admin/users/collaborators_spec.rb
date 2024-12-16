require "rails_helper"

describe "Collaborators", '
As a an Admin
I want to be able to add collaborators to any account
So that they can collaborate applications
', js: true do
  include ActiveJob::TestHelper

  let!(:admin) { create(:admin) }
  let(:existing_user) { create(:user, :completed_profile) }

  before do
    login_admin admin
    visit edit_admin_user_path(existing_user)
  end

  describe "Add Collaborator" do
    let(:email) { generate(:email) }
    let!(:user) { create(:user, email: email) }
    let(:form_answers) { [] }

    context "with the Account Admin role" do
      let(:role) { "Account admin" }

      before do
        search_for_user(email)
        transfer_user(role)
      end

      it "should transfer the user with the correct role" do
        expect(page).to have_content("#{email} successfully added to Collaborators!")
        expect(page).to have_content("#{email} successfully added to Collaborators!")
        login_as existing_user
        click_link "Collaborators"
        expect_to_see_user(user, role: "Admin and collaborator")
      end
    end

    context "with the regular role" do
      let(:role) { "Regular" }

      before do
        search_for_user(email)
        transfer_user(role)
      end

      it "should transfer the user with the correct role" do
        expect(page).to have_content("#{email} successfully added to Collaborators!")
        expect(page).to have_content("#{email} successfully added to Collaborators!")
        login_as existing_user
        click_link "Collaborators"
        expect_to_see_user(user, role: "Collaborator only")
      end
    end

    context "with form_answers" do
      let!(:form_answers) { create_list(:form_answer, 3, user: user, account: user.account) }
      let(:role) { "Account admin" }
      context "when transferring form_answers" do
        before do
          search_for_user(email)
          transfer_user(role, transfer_form_answers: true)
        end

        it "should transfer the form_answers and user with the correct role" do
          expect(page).to have_content("#{email} successfully added to Collaborators!")
          login_as existing_user, scope: :user
          click_link "Collaborators"
          expect_to_see_user(user, role: "Admin and collaborator")
          expect(existing_user.account.reload.form_answers).to eq(form_answers)
          expect(user.reload.form_answers).to eq(form_answers)
        end
      end

      context "when not transferring form_answers" do
        context "with no other users" do
          before do
            search_for_user(email)
            transfer_user(role, transfer_form_answers: false)
          end

          it "should transfer the user with the correct role" do
            expect(page).to have_content("#{email} successfully added to Collaborators!")
            login_as existing_user
            click_link "Collaborators"
            expect_to_see_user(user, role: "Admin and collaborator")
            expect(existing_user.account.reload.form_answers).to eq([])
            expect(user.reload.form_answers).to eq([])
          end
        end

        context "with other users" do
          let!(:other_user) { create(:user, :completed_profile, account: user.account) }

          before do
            search_for_user(email)
            transfer_user(role, transfer_form_answers: false, new_owner: other_user)
          end

          it "should transfer the user with the correct role" do
            expect(page).to have_content("#{email} successfully added to Collaborators!")
            login_as existing_user
            click_link "Collaborators"
            expect_to_see_user(user, role: "Admin and collaborator")
            expect(existing_user.account.reload.form_answers).to eq([])
            expect(user.reload.form_answers).to eq([])
            expect(other_user.reload.form_answers).to eq(form_answers)
          end
        end

        context "when the form_answers are in progress" do
          let!(:form_answers) { create_list(:form_answer, 3, :development, user: user, account: user.account) }

          before do
            search_for_user(email)
            transfer_user(role, transfer_form_answers: false)
          end

          it "should display an error" do
            expect(page).to have_content(
              "#{user.email} could not be added to Collaborators: User has applications in progress, and there are no other users on the account to transfer them to",
            )
          end
        end
      end
    end
  end

  def expect_to_see_user(user, role:)
    within "#user_#{user.id}" do
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(role)
    end
  end

  def transfer_user(role, transfer_form_answers: false, new_owner: nil)
    within(".js-admin-search-collaborators-results-box") do
      select role, from: "user[role]"
      select new_owner.email, from: "user[new_owner_id]" if new_owner
      check "user[transfer_form_answers]" if transfer_form_answers

      click_button "Transfer"
    end
  end

  def search_for_user(email)
    find("a[aria-controls='section-collaborators']").click

    within(".admin-search-collaborators-form") do
      fill_in "search[query]", with: email.to_s[2..-2]
      first("input[type='submit']").click
    end
  end
end
