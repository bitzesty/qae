require 'rails_helper'

RSpec.describe Eligibility::Innovation, type: :model do
  let(:account) { FactoryGirl.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Innovation.new(account: account)
      eligibility.innovative_product = 'yes'
      eligibility.number_of_innovative_products = 2
      eligibility.was_on_market_for_two_years = true
      eligibility.had_impact_on_commercial_performace_over_two_years = true

      expect { eligibility.save! }.to change {
        Eligibility::Innovation.count
      }.by(1)

      eligibility = Eligibility::Innovation.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_innovative_product
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Innovation.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.innovative_product = 'yes'
      eligibility.number_of_innovative_products = 2
      eligibility.was_on_market_for_two_years = true
      eligibility.had_impact_on_commercial_performace_over_two_years = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.innovative_product = 'yes'
      eligibility.number_of_innovative_products = 2
      eligibility.was_on_market_for_two_years = false
      eligibility.had_impact_on_commercial_performace_over_two_years = true

      expect(eligibility).not_to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Innovation.new(account: account) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([
                                           :innovative_product,
                                           :number_of_innovative_products,
                                           :was_on_market_for_two_years,
                                           :had_impact_on_commercial_performace_over_two_years
                                          ])
    end

    it 'does not return number of innovative products if account does not have them' do
      eligibility.innovative_product = 'no'
      expect(eligibility.questions).not_to include(:number_of_innovative_products)
    end
  end
end
