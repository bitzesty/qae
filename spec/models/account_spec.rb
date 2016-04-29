require "rails_helper"

describe Account do
  let(:user) { build(:user) }
  let(:account) { user.account }
  let(:current_year) { AwardYear.where(year: Date.today.year + 1).first_or_create }
  let(:previous_year) { AwardYear.where(year: current_year).first_or_create }

  describe "#has_award_in_this_year?" do
    describe "Trade" do
      let(:award_type) { "trade" }

      include_context "account applications number validation"
    end

    describe "Sustainable Development" do
      let(:award_type) { "development" }

      include_context "account applications number validation"
    end
  end
end
