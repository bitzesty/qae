require "rails_helper"
include Warden::Test::Helpers
include ActiveJob::TestHelper

describe "Collaborators", %q{
As a an Admin
I want to be able to add collaborators to any account
So that they can collaborate applications
} do

  let!(:admin) { create(:admin) }

  let!(:form_answer) do
    create :form_answer,
      :innovation,
      :submitted
  end

  let!(:account) do
    form_answer.account
  end

  before do
    login_admin admin
    visit admin_form_answer_path(form_answer)
  end

  describe "Add new Collaborator" do
    describe "Invalid Attempts", js: true do
      describe "Attempt to add person, which is already associated with another account which has application" do
        let!(:user_associated_with_another_account) do
          create :user,
            :completed_profile,
            first_name: "Applicant with account",
            role: "account_admin"
        end

        let!(:another_form_answer) do
          create :form_answer,
            :innovation,
            :submitted,
            user: user_associated_with_another_account
        end

        it "can't add" do
          find("a[aria-controls='section-company-details']").click

          within(".admin-search-collaborators-form") do
            fill_in "search[query]", with: "plicant with acc"
            first("input[type='submit']").click

            within(".js-admin-search-collaborators-results-box") do
              expect_to_see(user_associated_with_another_account.first_name)
              expect_to_see("can not be added as linked with another account!")
              expect(page).to have_no_link("Add")
            end
          end
        end
      end
    end

    describe "Success Add to Collaborators", js: true do
      let(:email) { generate(:email) }
      let!(:user) { create(:user, email: email) }

      it "should add user to collaborators with regular role" do
        find("a[aria-controls='section-company-details']").click()

        within(".admin-search-collaborators-form") do
          fill_in "search[query]", with: email.to_s[2..-2]
          first("input[type='submit']").click()

          within(".js-admin-search-collaborators-results-box") do
            expect_to_see(user.email)
            expect_to_see_no("can not be added as linked with another account!")
            expect(page).to have_link("Add")
          end
        end
      end
    end
  end
end
