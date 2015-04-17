require 'rails_helper'

RSpec.describe Eligibility::Development, :type => :model do
  let(:account) { FactoryGirl.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Development.new(account: account)
      eligibility.sustainable_development = 'yes'
      # eligibility.development_contributed_to_commercial_success = '1'

      expect { eligibility.save! }.to change {
        Eligibility::Development.count
      }.by(1)

      eligibility = Eligibility::Development.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_sustainable_development
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Development.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.sustainable_development = 'yes'
      # eligibility.development_contributed_to_commercial_success = true
      # eligibility.demonstrate_development_activities = true
      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.sustainable_development = 'no'
      # eligibility.development_contributed_to_commercial_success = true
      # demonstrate_development_activities = true

      expect(eligibility).not_to be_eligible
    end
  end
end
