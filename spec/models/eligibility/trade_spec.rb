require 'spec_helper'

RSpec.describe Eligibility::Trade, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Trade.new(user: user)
      eligibility.sales_above_100_000_pounds = '1'

      expect { eligibility.save! }.to change {
        Eligibility::Trade.count
      }.by(1)

      eligibility = Eligibility::Trade.last

      expect(eligibility.user).to eq(user)
      expect(eligibility.sales_above_100_000_pounds?).to be
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Trade.new(user: user) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.sales_above_100_000_pounds = true
      eligibility.any_dips_over_the_last_three_years = true
      eligibility.current_holder_of_qae_for_trade = false

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.sales_above_100_000_pounds = true
      eligibility.any_dips_over_the_last_three_years = false
      eligibility.current_holder_of_qae_for_trade = false

      expect(eligibility).not_to be_eligible
    end
  end
end
