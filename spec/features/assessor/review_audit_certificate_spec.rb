require "rails_helper"

describe "Assessor reviews the audit certificate" do
  let(:assessor) { create(:assessor, :lead_for_all) }
  let!(:form_answer) { create(:form_answer, :with_audit_certificate) }

  before do
    login_as(assessor, scope: :assessor)
    visit assessor_form_answer_path(form_answer)
  end

  context "without js" do
    it "reviews the audit certificate and marks it as not changed" do
      within "#new_review_audit_certificate" do
        first("input[type='radio']").set(true)
        click_button "Save"
      end

      within "#financial-summary" do
        expect(page).to have_selector("p", text: "No change necessary")
      end
    end

    it "reviews the audit certificate and marks it as changed" do
      description = "asdasddescription"
      within "#new_review_audit_certificate" do
        all("input[type='radio']").last.set(true)
        find("#review_audit_certificate_changes_description").set(description)
        click_button "Save"
      end

      within "#financial-summary" do
        expect(page).to have_selector("label", text: "Changes made")
        expect(page).to have_content(description)
      end
    end
  end
end
