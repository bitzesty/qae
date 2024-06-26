require "rails_helper"

Warden.test_mode!

describe "Judge is able do sign in", %(
         As a Judge
         I want to be able to sign in to the system
) do
  let(:judge) { create(:judge, password: "#ur9EkLm@1W+OaDvg") }

  it "allows judge to sign in" do
    visit judge_root_path

    fill_in "judge[email]", with: judge.email
    fill_in "judge[password]", with: "#ur9EkLm@1W+OaDvg"

    click_button "Sign in"

    expect(page).to have_content("Case Summaries")
  end
end
