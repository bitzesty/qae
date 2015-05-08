require "rails_helper"
include Warden::Test::Helpers

describe "Assessor feedback management", js: true do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let(:form_answer) { create(:form_answer, :innovation) }

  before do
    login_as(assessor, scope: :assessor)
  end

  describe "feedback submission" do
    it "submits feedback" do
      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click

      within "#section-feedback .level_of_innovation" do
        find("a.form-edit-link").click
        fill_in "feedback[level_of_innovation_strength]", with: "Feedback 101"
        click_button "Save"

        expect(page).to have_selector(".form-value", text: "Feedback 101")
      end
    end
  end

  describe "feedback approval" do
    it "approves submitted feedback" do
      feedback = form_answer.build_feedback
      feedback.submitted = true
      feedback.save!

      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click
      click_button "Approve feedback"

      expect(page).to have_no_selector(".btn-block", text: "Approve feedback")
    end
  end
end
