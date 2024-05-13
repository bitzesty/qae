require "rails_helper"
include Warden::Test::Helpers

describe "Admin: Download all Feedbacks as one pdf", '
As an Admin
I want to download all Feedbacks as one pdf per category from Dashboard
So that I can print and review application feedbacks
' do
  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  describe "Dashboard / Feedbacks section displaying" do
    before do
      visit downloads_admin_dashboard_index_path
    end

    it "should be links to download feedbacks" do
      FormAnswer::AWARD_TYPE_FULL_NAMES.each do |award_type, value|
        if award_type != "promotion"
          expect(page).to have_link("Download",
            href: admin_report_path(
              id: "feedbacks",
              category: award_type, format: :pdf, year: AwardYear.current.year,
            ),
          )
        end
      end
    end
  end

  describe "International Trade Award" do
    let(:award_type) { :trade }
    include_context "admin all feedbacks pdf generation"
  end

  describe "Innovation Award" do
    let(:award_type) { :innovation }
    include_context "admin all feedbacks pdf generation"
  end

  describe "Sustainable Development Award" do
    let(:award_type) { :development }
    include_context "admin all feedbacks pdf generation"
  end
end
