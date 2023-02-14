require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Collaborator registration flow" do
  let!(:acc_admin) { create(:user, role: "account_admin") }

  before do
    create(:settings, :submission_deadlines)
  end

  it "creates and account and collaborator is able to collaborate" do
    login_as(acc_admin, scope: :user)

    visit new_account_collaborator_path

    fill_in "Title", with: "Ms"
    fill_in("First name", with: "First Name")
    fill_in("Last name", with: "Last Name")
    fill_in("Job title", with: "job title")
    fill_in("Telephone number", with: "1231233214354235")
    fill_in("Email", with: "collab@example.com")
    first("input#collaborator_role_account_admin").set(true)

    click_button "Add the collaborator"

    collab = User.find_by_email("collab@example.com")
    collab.confirmed_at = Time.now
    collab.save!

    click_link "Sign out"

    login_as(collab.reload, scope: :user)
    visit root_path

    click_button("Save and continue")

    expect(page).to have_content("Contact preferences")
    click_button("Save and continue")

    fill_in "Name of the organisation", with: "Disney"
    fill_in "The organisation's main telephone number", with: "012312312"
    click_button("Save and continue")

    # collaborator page
    click_button("Save and continue")

    expect(page).to have_content("Applying for a King's Award for your organisation")
  end
end
