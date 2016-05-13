require 'rails_helper'

RSpec.describe Eligibility::Trade, type: :model do
  let(:account) { FactoryGirl.create(:account) }
  before do
    create :basic_eligibility, account: account
  end

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Trade.new(account: account)
      eligibility.sales_above_100_000_pounds = 'yes'
      eligibility.any_dips_over_the_last_three_years = 'no'
      eligibility.current_holder_of_qae_for_trade = 'no'

      expect { eligibility.save! }.to change {
        Eligibility::Trade.count
      }.by(1)

      eligibility = Eligibility::Trade.last

      expect(eligibility.account).to eq(account)
      expect(eligibility.sales_above_100_000_pounds?).to be
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Trade.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.sales_above_100_000_pounds = 'yes'
      eligibility.any_dips_over_the_last_three_years = false
      eligibility.growth_over_the_last_three_years = true
      eligibility.current_holder_of_qae_for_trade = false

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.sales_above_100_000_pounds = 'yes'
      eligibility.any_dips_over_the_last_three_years = true
      eligibility.current_holder_of_qae_for_trade = false
      eligibility.growth_over_the_last_three_years = true

      expect(eligibility).not_to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Trade.new(account: account) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([:sales_above_100_000_pounds,
                                          :any_dips_over_the_last_three_years,
                                          :growth_over_the_last_three_years])
    end

    it 'does not return QAE expiery date if account is not a QAE holder' do
      eligibility.current_holder_of_qae_for_trade = false
      expect(eligibility.questions).not_to include(:qae_for_trade_award_year)
    end
  end
end
