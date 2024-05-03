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
      expect(page).to have_css("#section-feedback .level_of_innovation", visible: true)
      within "#section-feedback .level_of_innovation" do
        expect(page).to have_link("Edit", class: "form-edit-link")
        click_link("Edit")
        expect(page).to have_css("textarea[name='feedback[level_of_innovation_strength]']", visible: true)
        fill_in "feedback[level_of_innovation_strength]", with: "Feedback 101"
        click_link "Save"

        wait_for_ajax
      end

      expect(page).to have_selector(".form-value", text: "Feedback 101")
    end
  end

  describe "feedback unlocking" do
    let!(:feedback) do
      feedback = form_answer.build_feedback
      feedback.submitted = true
      feedback.locked_at = Time.zone.now
      feedback.save!

      feedback
    end

    it "unlocks submitted feedback", js: true do
      visit assessor_form_answer_path(form_answer)
      find("#feedback-heading a").click

      expect(page).to have_selector(".feedback-holder", text: "Feedback Submitted")
      expect do
        find(:button, "Unlock").click
      end.to(change do
        feedback.reload.locked_at
      end)
    end
  end
end
