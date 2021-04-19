require "rails_helper"
include Warden::Test::Helpers

describe "Admin: ability to remove list of procedures attachment", %q{
As an Admin
I want to have ability to delete the list of procedures in case the user has uploaded it in error
So that User can re-upload list of procedures
} do

  let!(:form_answer) do
    create(:form_answer, :development, :submitted, :with_list_of_procedure)
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

      it "should not allow to remove list of procedures" do
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

      it "should not allow to remove list of procedures" do
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

    it "should remove list of procedures" do
      expect(form_answer.list_of_procedure.present?).to be_truthy

      wait_for_ajax

      expect {
        find(".js-remove-audit-certificate-link").click
        page.driver.browser.switch_to.alert.accept

        wait_for_ajax
      }.to change {
        form_answer.reload.list_of_procedure
      }
    end
  end
end
