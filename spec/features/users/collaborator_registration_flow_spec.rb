require "rails_helper"

Warden.test_mode!

describe "Collaborator registration flow" do
  let!(:award_year) { AwardYear.current }
  let!(:acc_admin) { create(:user, role: "account_admin") }

  before do
    create(:settings, :submission_deadlines)
    login_as(acc_admin, scope: :user)

    visit new_account_collaborator_path

    fill_in "Title", with: "Ms"
    fill_in("First name", with: "First Name")
    fill_in("Last name", with: "Last Name")
    fill_in("Job title", with: "job title")
    fill_in("Telephone number", with: "020 4551 0081")
    fill_in("Email", with: "collab@example.com")
    first("input#collaborator_role_account_admin").set(true)

    click_button "Add the collaborator"

    collab = User.find_by(email: "collab@example.com")
    collab.confirmed_at = Time.current
    collab.save!

    click_button "Sign out"

    login_as(collab.reload, scope: :user)
    visit root_path

    click_button("Save and continue")
  end

  it "creates and account and collaborator is able to collaborate" do
    expect(page).to have_content("Contact preferences")
    click_button("Save and continue")

    fill_in "Name of the organisation", with: "Disney"
    fill_in "The organisation's main telephone number", with: "020 4551 0082"
    click_button("Save and continue")

    # collaborator page
    click_button("Save and continue")

    expect(page).to have_content("Applying for a King's Award for your organisation")
  end

  context "when the company_phone_number is invalid" do
    it "displays an error message" do
      expect(page).to have_content("Contact preferences")
      click_button("Save and continue")

      fill_in "Name of the organisation", with: "Disney"
      fill_in "The organisation's main telephone number", with: "020 4551 008"
      click_button("Save and continue")

      expect(page).to have_content(
        I18n.t("activerecord.errors.models.user.attributes.company_phone_number.invalid"),
      )
    end
  end
end
