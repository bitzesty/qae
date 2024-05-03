require "rails_helper"

describe Account do
  let!(:account) do
    create(:account)
  end
  let!(:user) do
    create(:user, account:)
  end
  let!(:current_year) { AwardYear.where(year: Date.today.year + 1).first_or_create }
  let!(:previous_year) { AwardYear.where(year: current_year).first_or_create }

  describe "#has_award_in_this_year?" do
    describe "Trade" do
      let(:award_type) { :trade }

      include_context "account applications number validation"
    end

    describe "Sustainable Development" do
      let(:award_type) { :development }

      include_context "account applications number validation"
    end
  end

  describe "#other_submitted_applications" do
    it "returns submitted applications for this account, excluding the one passed as an argument" do
      included_fa_1 = create(:form_answer, :trade, :submitted, award_year: current_year, user:)
      included_fa_2 = create(:form_answer, :mobility, :submitted, award_year: current_year, user:)
      excluded_fa_1 = create(:form_answer, :innovation, :submitted, award_year: current_year, user:)
      excluded_fa_2 = create(:form_answer, :mobility, award_year: current_year, user:)
      excluded_fa_3 = create(:form_answer, :mobility, :submitted, award_year: current_year)

      expect(account.reload.other_submitted_applications(excluded_fa_1).pluck(:id)).to contain_exactly(included_fa_1.id, included_fa_2.id)
    end
  end
end
