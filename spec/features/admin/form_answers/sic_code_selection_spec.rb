require "rails_helper"

describe "SIC Code selection", "
  As Admin
  I want to set up the SIC Code per application." do
  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer, :trade, :submitted) }
  let(:selected) { "1623 - Manufacture of other builders' carpentry and joinery" }
  before do
    update_current_submission_deadline
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
    }.from("0111").to("1623")
    # 0111 - is default, came from spec/fixtures/*.json

    expect(page).to have_css("p", text: selected)
  end
end
