require "rails_helper"

describe "Assessor Suspension", type: :feature do
  let!(:admin) { create(:admin) }

  context "single suspension" do
    let!(:assessor) { create(:assessor) }

    before do
      login_admin admin
      visit admin_assessors_path
    end

    it "suspends the assessor" do
      click_link assessor.full_name
      click_link "Temporarily deactivate"

      choose "Yes, deactivate this assessor"

      click_button "Confirm"

      expect(page).to have_content("The assessor has been deactivated")
      expect(assessor.reload).to be_suspended
      expect(page).to have_content("DEACTIVATED")
    end

    it "reactivates the assessor" do
      assessor.suspend!

      click_link assessor.full_name
      click_link "Re-activate"

      choose "Yes, re-activate this assessor"

      click_button "Confirm"

      expect(page).to have_content("The assessor has been re-activated")
      expect(assessor.reload).not_to be_suspended
      expect(page).to have_content("ACTIVE")
    end
  end

  context "bulk suspension" do
    before do
      login_admin admin
      visit admin_assessors_path
    end

    let!(:assessor_trade) { create(:assessor, :lead_for_trade) }
    let!(:assessor_development) { create(:assessor, :regular_for_development) }
    let!(:assessor_innovation) { create(:assessor, :lead_for_innovation) }
    let!(:assessor_mobility) { create(:assessor, :lead_for_mobility) }

    it "suspends SD and IT assessors" do
      click_link "Edit assessors’ access to the system"

      within ".sd-it" do
        expect(page).to have_content("ACTIVE")

        click_link "Temporarily deactivate"
      end

      choose "Yes, deactivate assessors"
      click_button "Confirm"

      expect(page).to have_content("Assessors assigned to Sustainable Development and International Trade awards have been temporarily deactivated")

      within ".sd-it" do
        expect(page).to have_content("DEACTIVATED")
      end

      expect(assessor_trade.reload).to be_suspended
      expect(assessor_development.reload).to be_suspended
    end

    it "suspends PO and Inn assessors" do
      click_link "Edit assessors’ access to the system"

      within ".po-i" do
        expect(page).to have_content("ACTIVE")

        click_link "Temporarily deactivate"
      end

      choose "Yes, deactivate assessors"
      click_button "Confirm"

      expect(page).to have_content("Assessors assigned to Promoting Opportunity and Innovation awards have been temporarily deactivated")

      within ".po-i" do
        expect(page).to have_content("DEACTIVATED")
      end

      expect(assessor_mobility.reload).to be_suspended
      expect(assessor_innovation.reload).to be_suspended
    end

    it "re-activates SD and IT assessors" do
      assessor_trade.suspend!
      assessor_development.suspend!

      click_link "Edit assessors’ access to the system"

      within ".sd-it" do
        expect(page).to have_content("DEACTIVATED")

        click_link "Re-activate"
      end

      choose "Yes, re-activate assessors"
      click_button "Confirm"

      expect(page).to have_content("Assessors assigned to Sustainable Development and International Trade awards have been re-activated")

      within ".sd-it" do
        expect(page).to have_content("ACTIVE")
      end

      expect(assessor_trade.reload).not_to be_suspended
      expect(assessor_development.reload).not_to be_suspended
    end

    it "re-activates PO and Inn assessors" do
      assessor_innovation.suspend!
      assessor_mobility.suspend!

      click_link "Edit assessors’ access to the system"

      within ".po-i" do
        expect(page).to have_content("DEACTIVATED")

        click_link "Re-activate"
      end

      choose "Yes, re-activate assessors"
      click_button "Confirm"

      expect(page).to have_content("Assessors assigned to Promoting Opportunity and Innovation awards have been re-activated")

      within ".po-i" do
        expect(page).to have_content("ACTIVE")
      end

      expect(assessor_innovation.reload).not_to be_suspended
      expect(assessor_mobility.reload).not_to be_suspended
    end
  end
end
