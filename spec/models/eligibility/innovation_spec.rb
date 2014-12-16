require 'spec_helper'

RSpec.describe Eligibility::Innovation, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Innovation.new(user: user)
      eligibility.innovative_product = '1'
      eligibility.number_of_innovative_products = 2
      eligibility.was_on_market_for_two_years = true
      eligibility.had_impact_on_commercial_performace_over_two_years = true
      eligibility.innovation_recouped_investments = true

      expect { eligibility.save! }.to change {
        Eligibility::Innovation.count
      }.by(1)

      eligibility = Eligibility::Innovation.last

      expect(eligibility.user).to eq(user)
      expect(eligibility).to be_innovative_product
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Innovation.new(user: user) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.innovative_product = true
      eligibility.number_of_innovative_products = 2
      eligibility.was_on_market_for_two_years = true
      eligibility.had_impact_on_commercial_performace_over_two_years = true

      eligibility.innovation_recouped_investments = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.innovative_product = true
      eligibility.number_of_innovative_products = 2
      eligibility.was_on_market_for_two_years = false
      eligibility.had_impact_on_commercial_performace_over_two_years = true

      eligibility.innovation_recouped_investments = true

      expect(eligibility).not_to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Innovation.new(user: user) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([:innovative_product, :number_of_innovative_products, :was_on_market_for_two_years, :innovation_recouped_investments, :had_impact_on_commercial_performace_over_two_years])
    end

    it 'does not return number of innovative products if user does not have them' do
      eligibility.innovative_product = false
      expect(eligibility.questions).not_to include(:number_of_innovative_products)
    end
  end
end
