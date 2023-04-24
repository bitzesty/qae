require 'rails_helper'

RSpec.describe Eligibility::Mobility, type: :model do
  let(:account) { FactoryBot.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Mobility.new(account: account)
      eligibility.promoting_social_mobility = 'yes'
      eligibility.social_mobility_activities = 'yes'

      expect { eligibility.save! }.to change {
        Eligibility::Mobility.count
      }.by(1)

      eligibility = Eligibility::Mobility.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_promoting_social_mobility
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Mobility.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.promoting_opportunity_involvement = 'Our main activity is focused on something else, but we have activities or initiatives that are positively supporting social mobility'
      eligibility.can_provide_financial_figures = 'yes'
      eligibility.full_time_employees = 'yes'
      eligibility.promoting_social_mobility = 'yes'
      eligibility.participants_based_in_uk = 'yes'
      eligibility.social_mobility_activities = 'yes'
      eligibility.active_for_atleast_two_years = 'yes'
      eligibility.evidence_of_impact = 'yes'
      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.promoting_social_mobility = 'yes'
      eligibility.social_mobility_activities = 'no'

      expect(eligibility).not_to be_eligible
    end
  end

    describe '.award_name' do
    let(:eligibility) { Eligibility::Mobility.new(account: account) }

    it 'should return award_name' do
      expect(eligibility.class.award_name).to eq "Social Mobility Award"
    end
  end
end
