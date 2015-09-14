require "rails_helper"
include Warden::Test::Helpers

describe "SIC Code selection", "
  As Admin
  I want to set up the SIC Code per application." do

  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :trade, :submitted) }
  let(:selected) { "1623 - Manufacture of other builders' carpentry and joinery" }
  before do
    Settings.current_submission_deadline.update(trigger_at: DateTime.now - 1.day)
    login_admin admin
    visit admin_form_answer_path(form_answer)
  end

  it "sets up the sic code per form" do
    find("#form_answer_sic_code option[value='1623']").select_option
    expect {
      within ".sic-code" do
        click_button "Save"
      end
    }.to change {
      form_answer.reload.sic_code
    }.from(nil).to("1623")

    expect(page).to have_css("p", text: selected)
  end
end
