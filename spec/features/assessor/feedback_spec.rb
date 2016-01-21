require "rails_helper"
include Warden::Test::Helpers

describe "Assessor feedback management" do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let(:form_answer) { create(:form_answer, :innovation, state: "not_awarded") }

  before do
    login_as(assessor, scope: :assessor)
  end

  describe "feedback submission" do
    it "submits feedback", js: true do
      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click

      within "#section-feedback .level_of_innovation" do
        find("a.form-edit-link").click
        fill_in "feedback[level_of_innovation_strength]", with: "Feedback 101"
        click_link "Save"

        expect(page).to have_selector(".form-value", text: "Feedback 101")
      end
    end
  end

  describe "feedback unlocking" do
    before do
      feedback = form_answer.build_feedback
      feedback.submitted = true
      feedback.locked_at = Time.zone.now
      feedback.save!

      form_answer.reload
    end

    it "unlocks submitted feedback", js: true do
      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click
      expect(page).to have_selector(".feedback-holder", text: "Feedback Submitted")
      click_button "Unlock"

      expect(page).to have_no_selector(".feedback-holder", text: "Feedback Submitted")
    end
  end
end
