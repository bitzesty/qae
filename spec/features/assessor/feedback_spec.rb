require "rails_helper"
include Warden::Test::Helpers

describe "Assessor feedback management" do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let(:form_answer) { create(:form_answer, :innovation, state: "not_awarded") }

  before do
    login_as(assessor, scope: :assessor)
  end

  describe "feedback submission" do
    before do
      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click

      within "#section-feedback .level_of_innovation" do
        find("a.form-edit-link").click
      end
    end

    it "submits feedback", js: true do
      within "#section-feedback .level_of_innovation" do
        fill_in "feedback[level_of_innovation_strength]", with: "Feedback 101"
        click_link "Save"

        wait_for_ajax
      end

      expect(page).to have_selector(".form-value", text: "Feedback 101")
    end
  end

  describe "feedback unlocking" do
    before do
      feedback = form_answer.build_feedback
      feedback.submitted = true
      feedback.locked_at = Time.zone.now
      feedback.save!

      form_answer.reload

      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click
    end

    it "unlocks submitted feedback", js: true do
      expect(page).to have_selector(".feedback-holder", text: "Feedback Submitted")
      click_button "Unlock"
      wait_for_ajax

      expect(page).to have_no_selector(".feedback-holder", text: "Feedback Submitted")
    end
  end
end
