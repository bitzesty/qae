require "rails_helper"

describe Account do
  let(:user) { FactoryGirl.build(:user) }
  let(:account) { user.account }
  let(:current_year) { "20#{FormAnswer::CURRENT_AWARD_YEAR}".to_i }
  let(:previous_year) { current_year - 1 }

  describe "#has_trade_award_in_this_year?" do
    let!(:innovation_award) { create(:form_answer, :innovation, user: user) }

    it "returns false when there is no trade award" do
      expect(account.reload.has_trade_award_in_this_year?).to be_falsey
    end

    it "returns false when there is trade award, but for previous year" do
      create(:form_answer, :trade, user: user, award_year: previous_year)
      expect(account.reload.has_trade_award_in_this_year?).to be_falsey
    end

    it "returns true when there is a trade award for current year" do
      create(:form_answer, :trade, user: user, award_year: current_year)
      expect(account.reload.has_trade_award_in_this_year?).to be_truthy
    end
  end
end
