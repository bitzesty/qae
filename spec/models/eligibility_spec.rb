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

  describe '#eligible?' do
    let(:eligibility) { Eligibility.new(user: user) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible in the middle of the survey' do
      eligibility.current_step = :based_in_uk
      eligibility.kind = 'application'
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true

      expect(eligibility).to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.kind = 'application'
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true
      eligibility.self_contained_enterprise = true
      eligibility.has_management_and_two_employees = true
      eligibility.demonstrated_comercial_success = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.kind = 'application'
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true
      eligibility.self_contained_enterprise = true
      eligibility.has_management_and_two_employees = false
      eligibility.demonstrated_comercial_success = true

      expect(eligibility).not_to be_eligible
    end
  end
end
