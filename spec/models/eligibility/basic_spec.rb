require 'rails_helper'

RSpec.describe Eligibility::Basic, type: :model do
  let(:account) { FactoryBot.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Basic.new(account: account)
      eligibility.based_in_uk = '1'

      expect { eligibility.save }.to change {
        Eligibility::Basic.count
      }.by(1)

      eligibility = Eligibility::Basic.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_based_in_uk
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Basic.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is eligible in the middle of the survey' do
      eligibility.current_step = :based_in_uk
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true

      expect(eligibility).to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true
      eligibility.do_you_file_company_tax_returns = true
      eligibility.self_contained_enterprise = true
      eligibility.adherence_to_esg_principles = true

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.organization_kind = 'charity'
      eligibility.based_in_uk = true
      eligibility.self_contained_enterprise = true
      eligibility.adherence_to_esg_principles = false

      expect(eligibility).not_to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Basic.new(account: account) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([
        :based_in_uk,
        :do_you_file_company_tax_returns,
        :organization_kind,
        :industry,
        :self_contained_enterprise,
        :current_holder,
        :adherence_to_esg_principles
      ])
    end

    it 'does not return industry for charity' do
      eligibility.organization_kind = 'charity'
      expect(eligibility.questions).not_to include(:industry)
    end
  end

  describe '#skipped?' do
    it 'should return false' do
      eligibility = Eligibility::Basic.new(account: account)
      expect(eligibility.skipped?).to be_falsey
    end
  end
end
