require "rails_helper"
include Warden::Test::Helpers

describe "Lord-Lieutenant data sharing" do
  let(:new_user) { create :user }

  let(:returning_user) { create(:user, :completed_profile) }

  context "As a new user" do
    before do
      login_as new_user
      visit dashboard_path
    end

    it "should direct the user through the setup wizard" do
      expect_to_see "My Details"
      expect_to_see "Organisation Details"
      expect_to_see "Contact Preferences"
      expect_to_see "Collaborators"
    end
  end

  context "As a returning user" do
    context "who has previously submitted their data sharing preference for Lord-Lieutenants" do
      before do
        login_as returning_user
        visit dashboard_path
      end

      it "should allow the user to view their dashboard" do
        expect(current_path).to eql(dashboard_path)
      end
    end

    context "who hasn't previously submitted their data sharing preference for Lord-Lieutenants" do
      before do
        returning_user.update(agree_sharing_of_details_with_lieutenancies: nil)
        login_as returning_user
        visit dashboard_path
      end

      it "should direct the user to the 'Additional Contact Preferences' page" do
        expect(current_path).to eql(additional_contact_preferences_account_path)
      end

      context "and submits their preference" do
        before do
          choose "Yes"
          click_on "Confirm"
        end

        it "should redirect the user to their dashboard" do
          expect(current_path).to eql(dashboard_path)
        end
      end

      context "and submits the form without choosing 'Yes' or 'No'" do
        it "should render an error" do
          click_on "Confirm"
          expect_to_see "This field cannot be blank"
        end
      end
    end
  end
end
