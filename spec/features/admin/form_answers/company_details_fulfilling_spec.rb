require "rails_helper"
include Warden::Test::Helpers

describe "Admin fulfills the company details" do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :trade) }

  before do
    login_admin(admin)
    form_answer.update_column(:submitted_at, Time.current)
    Settings.current_submission_deadline.update(trigger_at: DateTime.now - 1.day)
    visit admin_form_answer_path(form_answer)
  end

  it "fulfills the address information" do
    building = "buildingbuildingbuilding"
    within ".company-address-form" do
      find(".form_answer_data_organization_address_building input").set(building)
      click_button "Save"
    end
    expect(form_answer.reload.document["organization_address_building"]).to eq(building)
  end

  it "fulfills the company name" do
    name = "namenana123"
    within ".company-name-form" do
      find(".form_answer_company_or_nominee_name input").set(name)
      click_button "Save"
    end
    expect(form_answer.reload.company_or_nominee_name).to eq(name)
  end

  it "can see the edit buttons" do
    within ".company-details-forms" do
      expect(page).to have_selector("input[type='submit']", count: 13)
    end
  end
end
