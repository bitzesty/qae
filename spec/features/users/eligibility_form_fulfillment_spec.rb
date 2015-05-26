require "rails_helper"
include Warden::Test::Helpers

describe "User account creation process", js: true do
  it "creates the User account" do
    visit new_user_registration_path
    fill_in("Email", with: "test@example.com")
    fill_in("Password", with: "asldkj902lkads-0asd")
    fill_in("Password confirmation", with: "asldkj902lkads-0asd")
    find("#user_agreed_with_privacy_policy").set(true)
    click_button "Create account"
    expect(page).to have_content("Sign-up complete")
  end

  context "Account details fulfillment" do
    let!(:user) { create(:user) }

    before do
      create(:settings, :submission_deadlines)
      login_as(user, scope: :user)
    end

    let(:phone_number) { "1231233214354235" }
    let(:company_name) { "BitZestyOrg" }

    it "adds the Account details" do
      visit root_path
      fill_in("Title", with: "Mr")
      fill_in("First name", with: "FirstName")
      fill_in("Last name", with: "LastName")
      fill_in("Your job title", with: "job title")
      fill_in("Your telephone number", with: phone_number)

      click_button("Save and continue")
      expect(page).to have_content("Organisation Details")

      fill_in("Name of your organisation", with: company_name)
      fill_in("Main telephone number", with: "9876544")
      click_button("Save and continue")

      expect(page).to have_content("Contact Preferences")
      click_button("Save and continue")
      expect(page).to have_content("Your account details were successfully saved")

      user.reload

      expect(user.phone_number).to eq(phone_number)
      expect(user.company_name).to eq(company_name)
    end
  end

  context "Eligibility form fulfillment" do
    let!(:user) { create(:user, :completed_profile) }

    before do
      create(:account, owner: user)
      create(:settings, :submission_deadlines)
      login_as(user, scope: :user)
    end

    it "proceeds the eligibility form for trade", focus: true do
      visit dashboard_path
      first("a", text: "New application").click
      fill_in("nickname", with: "trade nick")
      click_button("Save and start eligibility")
      # click_yes # to resolve
    end
  end
end

def click_yes
  first(".question-body .input").set(true)
  click_button "Continue"
end
