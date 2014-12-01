require 'spec_helper'

RSpec.describe Eligibility, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility.new(user: user)
      eligibility.kind = 'application'
      eligibility.based_in_uk = '1'

      expect { eligibility.save }.to change {
        Eligibility.count
      }.by(1)

      eligibility = Eligibility.last

      expect(eligibility.user).to eq(user)
      expect(eligibility.kind).to eq('application')
      expect(eligibility).to be_based_in_uk
    end
  end
end
