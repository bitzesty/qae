require "rails_helper"
include Warden::Test::Helpers

describe "Press Summary" do
  before do
    deadline = Settings.current.deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
    deadline.update_column(:trigger_at, Time.current + 1.day)
  end

  context "business form" do
    let!(:form_answer) do
      create :form_answer, :innovation
    end

    let!(:press_summary) { create :press_summary, form_answer:, approved: true, submitted: true }

    it "should allow to fill the form untill deadline" do
      visit users_form_answer_press_summary_url(form_answer, token: press_summary.token)

      fill_in "Name", with: "Jon"
      fill_in "Email", with: "jon@example.com"
      fill_in "Telephone", with: "1234567"

      click_button "Save"

      expect(page).to have_content("Press Book Notes successfully updated")
      expect(press_summary.reload.applicant_submitted).to be_falsey
    end

    it "should not allow to fill the form after the deadline" do
      deadline = Settings.current.deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
      deadline.update_column(:trigger_at, Time.current - 1.day)

      visit users_form_answer_press_summary_url(form_answer, token: press_summary.token)

      expect(page).to have_content("Sorry, you cannot amend Press Book Notes comments anymore")
    end
  end

  context "promotion form" do
    let!(:form_answer) do
      create :form_answer, :promotion
    end

    let!(:press_summary) { create :press_summary, form_answer:, approved: true, submitted: true }

    it "should show acceptance form before press summary form" do
      visit users_form_answer_press_summary_url(form_answer, token: press_summary.token)

      choose "Yes"

      click_button "Continue"

      fill_in "Name", with: "Jon"
      fill_in "Email", with: "jon@example.com"
      fill_in "Telephone", with: "1234567"

      click_button "Save"

      expect(page).to have_content("Press Book Notes successfully updated")
      expect(press_summary.reload.applicant_submitted).to be_falsey
    end

    it "redirects to home page without acceptance" do
      visit users_form_answer_press_summary_url(form_answer, token: press_summary.token)

      choose "No"

      click_button "Continue"

      expect(page).to have_no_content(
        "Please check that the Press Book Notes are factually accurate:",
      )
    end
  end
end
