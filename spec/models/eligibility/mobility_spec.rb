require 'rails_helper'

RSpec.describe Eligibility::Mobility, type: :model do
  let(:account) { FactoryGirl.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Mobility.new(account: account)
      eligibility.programme_validation = 'yes'
      eligibility.programme_operation = 'yes'
      eligibility.programme_commercial_success = 'yes'

      expect { eligibility.save! }.to change {
        Eligibility::Mobility.count
      }.by(1)

      eligibility = Eligibility::Mobility.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_programme_commercial_success
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Mobility.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.programme_validation = 'yes'
      eligibility.programme_operation = 'yes'
      eligibility.programme_commercial_success = 'yes'
      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.programme_validation = 'yes'
      eligibility.programme_operation = 'no'
      eligibility.programme_commercial_success = 'yes'

      expect(eligibility).not_to be_eligible
    end
  end
end
