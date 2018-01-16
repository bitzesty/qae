require "rails_helper"

describe Account do
  let!(:account) do
    create(:account)
  end
  let!(:user) do
    create(:user, account: account)
  end
  let!(:current_year) { AwardYear.where(year: Date.today.year).first_or_create }
  let!(:previous_year) { AwardYear.where(year: Date.today.year - 1).first_or_create }

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
end
