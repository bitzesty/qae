require "rails_helper"
include Warden::Test::Helpers

describe "As Admin I want to change the applications states.", js: true do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  it "changes the state from application_to_progress to submitted" do
    within ".section-applicant-status" do
      expect(page).to have_selector(".state-toggle", text: "Application in progress")
      click_button "Application in progress"
      within ".dropdown-menu" do
        click_link "Submitted"
      end
      expect(page).to have_selector(".state-toggle", text: "Submitted")
      wait_for_ajax
      expect(form_answer.reload.state).to eq("submitted")
    end
  end
end
