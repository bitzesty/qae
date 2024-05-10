require "rails_helper"
include Warden::Test::Helpers

describe "Users search", "
  As Admin
  I want to search users." do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user, first_name: "name-12345") }

  before do
    create(:user)
    login_admin admin
    visit admin_users_path
  end

  context "success searching" do
    context "by user name" do
      it "search for users with first name", js: true do
        within ".search-input" do
          fill_in "search_query", with: user.first_name
          click_button :submit
        end

        within ".admin-table" do
          expect(page).to have_selector("td.td-title", count: 1)
        end
      end
    end
  end
end
