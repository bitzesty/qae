require "rails_helper"

describe "As Admin I want to change the applications states.", js: true do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, state: "assessment_in_progress") }

  before do
    setting = Settings.current_submission_deadline
    setting.update(trigger_at: DateTime.now - 1.hour)
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  it "changes the state from application_to_progress to submitted" do
    within ".section-applicant-status" do
      expect(page).to have_selector(".state-toggle", text: "Assessment in progress")
      click_button "Assessment in progress"
      within ".dropdown-menu" do
        click_link "Recommended"
      end
      expect(page).to have_selector(".state-toggle", text: "Recommended")
      wait_for_ajax
      expect(form_answer.reload.state).to eq("recommended")
    end
  end
end
