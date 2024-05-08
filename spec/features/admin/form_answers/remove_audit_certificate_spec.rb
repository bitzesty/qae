require "rails_helper"
include Warden::Test::Helpers

describe "Admin: ability to remove Verification of Commercial Figures", %q{
As an Admin
I want to have ability to delete the Verification of Commercial Figures in case the user has uploaded it in error
So that User can re-upload Verification of Commercial Figures
} do

  let!(:form_answer) do
    create(:form_answer, :submitted, :with_audit_certificate)
  end

  describe "Policies" do
    let(:target_url) do
      assessor_form_answer_path(form_answer)
    end

    describe "Lead Assessor" do
      let!(:lead_assessor) { create(:assessor, :lead_for_all) }

      before do
        login_as(lead_assessor, scope: :assessor)
        visit target_url
      end

      it "should not allow to remove Verification of Commercial Figures" do
        expect(page).to_not have_selector(:css, "a.js-remove-audit-certificate-link")
      end
    end

    describe "Primary Assessor" do
      let!(:primary_assessor) { create(:assessor, :regular_for_all) }
      let!(:primary) { form_answer.assessor_assignments.primary }

      before do
        primary.assessor = primary_assessor
        primary.save!

        login_as(primary_assessor, scope: :assessor)
        visit target_url
      end

      it "should not allow to remove Verification of Commercial Figures" do
        expect(page).to_not have_selector(:css, "a.js-remove-audit-certificate-link")
      end
    end
  end

  describe "Removing", js: true do
    let!(:admin) { create(:admin) }

    before do
      login_admin(admin)

      visit admin_form_answer_path(form_answer)
    end

    it "should remove Verification of Commercial Figures" do
      expect(form_answer.audit_certificate.present?).to be_truthy

      wait_for_ajax

      expect {
        find(".js-remove-audit-certificate-link").click()
        page.driver.browser.switch_to.alert.accept

        wait_for_ajax
      }.to change {
        form_answer.reload.audit_certificate
      }
    end
  end
end
