require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

describe "Judge is able to view case summaries", %(
         As a Judge
         I want to be able view and download assigned CS
) do
  let(:judge) { create(:judge, :trade, :innovation) }

  it "allows judge view case summaries in accordance with roles" do
    login_as(judge, scope: :judge)
    visit judge_root_path

    expect(page).to have_content("International Trade (3 years)")
    expect(page).to have_content("International Trade (6 years)")
    expect(page).to have_content("Innovation")
    expect(page).not_to have_content("Sustainable Development")
    expect(page).not_to have_content("Promoting Opportunity")
  end
end
