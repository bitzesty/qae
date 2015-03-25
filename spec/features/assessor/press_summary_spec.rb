require "rails_helper"
include Warden::Test::Helpers

describe "Assessor press_summary management", js: true do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, :innovation) }

  before do
    login_as(assessor, scope: :assessor)
  end

  describe "press_summary submission" do
    it "submits press_summary" do
      visit assessor_form_answer_path(form_answer)
      find("#press-summary-heading a").click

      within "#section-press-summary" do
        find("a.form-edit-link").click
        fill_in "press_summary[body]", with: "Press Summary 101"
        click_button "Save"

        expect(page).to have_selector(".form-value", text: "Press Summary 101")
      end
    end
  end

  describe "press_summary approval" do
    it "approves submitted press_summary" do
      press_summary = form_answer.build_press_summary
      press_summary.body = "body"
      press_summary.save!

      visit assessor_form_answer_path(form_answer)
      find("#press-summary-heading a").click
      click_button "Approve Press Summary"

      expect(page).to have_no_selector(".btn-block", text: "Approve Press Summary")
    end
  end
end
