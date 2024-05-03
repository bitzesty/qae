require "rails_helper"

RSpec.describe Eligibility::Trade, type: :model do
  let(:account) { FactoryBot.create(:account) }
  before { create :basic_eligibility, account: }

  context "validation" do
    it "should validate current_holder_of_qae_for_trade" do
      eligibility = Eligibility::Trade.create(account:)
      eligibility.current_holder_of_qae_for_trade = nil
      eligibility.force_validate_now = true
      allow_any_instance_of(Eligibility).to receive(:current_step) { :current_holder_of_qae_for_trade }
      eligibility.save
      expect(eligibility.errors[:current_holder_of_qae_for_trade].present?).to be_truthy
    end
  end
  context "answers storage" do
    it "saves and reads answers" do
      eligibility = Eligibility::Trade.new(account:)
      eligibility.sales_above_100_000_pounds = "yes"
      eligibility.any_dips_over_the_last_three_years = "no"
      eligibility.current_holder_of_qae_for_trade = "no"

      expect { eligibility.save! }.to change {
        Eligibility::Trade.count
      }.by(1)

      eligibility = Eligibility::Trade.last

      expect(eligibility.account).to eq(account)
      expect(eligibility.sales_above_100_000_pounds?).to be
    end
  end

  describe "#eligible?" do
    let(:eligibility) { Eligibility::Trade.new(account:) }

    it "is not eligible by default" do
      expect(eligibility).not_to be_eligible
    end

    it "is eligible when all questions are answered correctly" do
      eligibility.growth_over_the_last_three_years = true
      eligibility.sales_above_100_000_pounds = "yes"
      eligibility.any_dips_over_the_last_three_years = false
      eligibility.has_management_and_two_employees = true
      eligibility.current_holder_of_qae_for_trade = false

      expect(eligibility).to be_eligible
    end

    it "is not eligible when not all answers are correct" do
      eligibility.sales_above_100_000_pounds = "yes"
      eligibility.any_dips_over_the_last_three_years = true
      eligibility.current_holder_of_qae_for_trade = false
      eligibility.growth_over_the_last_three_years = true

      expect(eligibility).not_to be_eligible
    end
  end

  describe "#questions" do
    let(:eligibility) { Eligibility::Trade.new(account:) }

    it "returns all questions for new eligibility" do
      expect(eligibility.questions).to eq(%i[growth_over_the_last_three_years
                                             sales_above_100_000_pounds
                                             any_dips_over_the_last_three_years
                                             has_management_and_two_employees])
    end

    it "Does not return holder award questions" do
      expect(eligibility.questions).not_to include(:current_holder_of_qae_for_trade)
      expect(eligibility.questions).not_to include(:qae_for_trade_award_year)
    end

    it "Returns question for current holder of an Award for International Trade" do
      account.basic_eligibility.update(current_holder: "yes")
      expect(eligibility.questions).to include(:current_holder_of_qae_for_trade)
    end

    it "Returns question for year of the Award for International Trade" do
      account.basic_eligibility.update(current_holder: "yes")
      eligibility.current_holder_of_qae_for_trade = true

      expect(eligibility.questions).to include(:qae_for_trade_award_year)
    end
  end

  describe ".award_name" do
    let(:eligibility) { Eligibility::Trade.new(account:) }

    it "should return award_name" do
      expect(eligibility.class.award_name).to eq "International Trade Award"
    end
  end
end
