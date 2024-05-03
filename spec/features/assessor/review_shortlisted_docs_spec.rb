require "rails_helper"
include Warden::Test::Helpers

describe "Assessor reviews the shortlisted docs" do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, :development, :recommended) }
  let!(:sdw) { create(:shortlisted_documents_wrapper, form_answer:) }

  before do
    create(:vat_returns_file, shortlisted_documents_wrapper: sdw)
    sdw.submit

    login_as(assessor, scope: :assessor)
    visit assessor_form_answer_path(form_answer)
  end

  context "without js" do
    it "reviews the shortlisted docs and marks it as not changed" do
      within "#new_shortlisted_documents_review_form" do
        first("input[type='radio']").set(true)
        click_button "Save"
      end

      within "#financial-summary" do
        expect(page).to have_selector("label", text: "No change necessary")
      end
    end

    it "reviews the shortlisted docs and marks it as changed" do
      description = "asdasddescription"
      within "#new_shortlisted_documents_review_form" do
        all("input[type='radio']").last.set(true)
        find("#shortlisted_documents_review_form_changes_description").set(description)
        click_button "Save"
      end

      within "#financial-summary" do
        expect(page).to have_selector("label", text: "Changes made")
        expect(page).to have_content(description)
      end
    end
  end
end
