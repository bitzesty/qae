require 'spec_helper'

RSpec.describe Eligibility::Development, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Development.new(user: user)
      eligibility.sustainable_development = '1'
      eligibility.development_contributed_to_commercial_success = '1'

      expect { eligibility.save! }.to change {
        Eligibility::Development.count
      }.by(1)

      eligibility = Eligibility::Development.last

      expect(eligibility.user).to eq(user)
      expect(eligibility).to be_sustainable_development
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Development.new(user: user) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.sustainable_development = true
      eligibility.development_contributed_to_commercial_success = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.sustainable_development = false
      eligibility.development_contributed_to_commercial_success = true

      expect(eligibility).not_to be_eligible
    end
  end
end
