require "rails_helper"
include Warden::Test::Helpers

describe "Admin withdraws application", js: true do
  let(:admin) { create(:admin) }

  let(:user) do
    FactoryGirl.create :user, :completed_profile, first_name: "Test User john"
  end

  let(:form_answer) do
    FactoryGirl.create :form_answer, :innovation,
                                     user: user,
                                     urn: "QA0001/19T",
                                     document: { company_name: "Bitzesty" }
  end

  before do
    login_admin(admin)

    visit admin_form_answer_path(form_answer)
  end

  it "I should be able to withdraw application" do
    find(".state-toggle").click
    click_button "Withdraw"

    expect(page).to have_selector(".state-toggle", text: "Withdraw")
  end
end
