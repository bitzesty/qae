require "rails_helper"

include Warden::Test::Helpers
describe "Admin sets up previous winnings" do
  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  context "addition" do
    let!(:form_answer) { create(:form_answer) }

    it "adds previous winning" do
      within ".previous-wins" do
        first("option[value='innovation2']").select_option
        first("option[value='2014']").select_option
      end
      click_button "Update details"
      within ".previous-wins" do
        expect(page).to have_selector(".form-fields", count: 2)
      end
    end
  end

  context "deletion" do
    let!(:form_answer) { create(:previous_win).form_answer }
    it "deletes previous winning" do
      within ".previous-wins" do
        expect(page).to have_selector(".form-fields", count: 2)
        first("input[type='checkbox']").set(true)
      end
      click_button "Update details"

      within ".previous-wins" do
        expect(page).to have_selector(".form-fields", count: 1)
      end
    end
  end
end
