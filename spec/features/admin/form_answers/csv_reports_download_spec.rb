require "rails_helper"
include Warden::Test::Helpers

describe "Admin downloads CSV reports" do
  let!(:admin) { create(:admin) }
  before { login_admin(admin) }

  it "downloads CSV report" do
    visit downloads_admin_dashboard_index_path
    links_count = 0

    within first(".download-list") do
      links_count = all(:css, "a.download-link", text: "Download").count
    end

    (1..links_count).each do |i|
      within first(".download-list") do
        link = all(:css, "a.download-link", text: "Download")[i - 1]

        link.click

        if i == 5 # press book, 5th link
          expect(page.response_headers["Content-Type"]).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
        else
          expect(page.response_headers["Content-Type"]).to include("text/csv")
        end
      end

      visit downloads_admin_dashboard_index_path
    end

    expect(AuditLog.count).to eq(6)
    log = AuditLog.last
    expect(log.subject).to eq(admin)
    expect(log.action_type).to eq("reception-buckingham-palace")
  end
end
