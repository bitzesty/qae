require "rails_helper"
include Warden::Test::Helpers

describe "Assessor Suspension", type: :feature do
  let!(:admin) { create(:admin) }
  let!(:assessor) { create(:assessor) }

  before do
    login_admin admin
    visit admin_assessors_path
  end

  it "suspends the assessor" do
    click_link assessor.full_name
    click_link "Temporarily deactivate"

    choose "Yes, deactivate this assessor"

    click_button "Confirm"

    expect(page).to have_content("The assessor has been deactivated")
    expect(assessor.reload).to be_suspended
    expect(page).to have_content("DEACTIVATED")
  end

  it "reactivates the assessor" do
    assessor.suspend!

    click_link assessor.full_name
    click_link "Re-activate"

    choose "Yes, re-activate this assessor"

    click_button "Confirm"

    expect(page).to have_content("The assessor has been re-activated")
    expect(assessor.reload).not_to be_suspended
    expect(page).to have_content("ACTIVE")
  end
end
