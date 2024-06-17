require "rails_helper"

describe "Assessor press_summary management", js: true do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, :innovation, state: "awarded") }

  before do
    login_as(assessor, scope: :assessor)
  end

  describe "press_summary submission" do
    before do
      visit assessor_form_answer_path(form_answer)
    end

    it "submits press_summary" do
      find("#press-summary-heading a").click

      within "#section-press-summary .press-summary-body-block" do
        find("a.form-edit-link").click
        fill_in "press_summary[body]", with: "Press Book Notes 101"
        click_button "Save"

        expect(page).to have_selector(".form-value", text: "Press Book Notes 101")
      end
    end
  end

  describe "press_summary approval" do
    let!(:press_summary) { create :press_summary, form_answer: form_answer }

    before do
      press_summary.body = "body"
      press_summary.save!

      visit assessor_form_answer_path(form_answer)
    end

    it "submit press_summary" do
      find("#press-summary-heading a").click
      click_button "Submit Press Book Notes"

      expect(page).to have_no_selector(".btn-block", text: "Submit Press Book Notes")
    end
  end
end
