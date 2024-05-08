require "rails_helper"
include Warden::Test::Helpers

describe "Admin: Download all Case Summary as one pdf", %q{
As an Admin
I want to download all Case Summary PDFS as one pdf per category from Dashboard
So that I can print and review application case summaries
} do

  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  describe "Dashboard / Case Summary section displaying" do
    before do
      visit downloads_admin_dashboard_index_path
    end

    it "should be links to download case summaries" do
      FormAnswer::CURRENT_AWARD_TYPE_FULL_NAMES.each do |award_type, value|
        ops = {
          id: "case_summaries",
          category: award_type, format: :pdf,
          year: AwardYear.current.year,
        }

        if award_type == "trade"
          [3, 6].map do |i|
            expect(page).to have_link("Download",
              href: admin_report_path(
                ops.merge({years_mode: i}),
              ),
            )
          end
        else
          expect(page).to have_link("Download",
            href: admin_report_path(
              ops,
            ),
          )
        end
      end
    end
  end

  describe "International Trade Award" do
    let(:award_type) { :trade }
    include_context "admin all case summaries pdf generation"
  end

  describe "Innovation Award" do
    let(:award_type) { :innovation }
    include_context "admin all case summaries pdf generation"
  end

  describe "Sustainable Development Award" do
    let(:award_type) { :development }
    include_context "admin all case summaries pdf generation"
  end

  describe "Enterprise Promotion Award" do
    let(:award_type) { :mobility }
    include_context "admin all case summaries pdf generation"
  end
end
