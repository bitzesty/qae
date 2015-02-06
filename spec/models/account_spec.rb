require 'rails_helper'

describe Account do
  let(:user) { FactoryGirl.build(:user) }
  let(:account) { user.account }

  describe '#has_trade_award?' do
    let!(:innovation_award) { create(:form_answer, :innovation, user: user) }

    it 'returns false when there is no trade award' do
      expect(account).not_to have_trade_award
    end

    it 'returns true when there is a trade award' do
      create(:form_answer, :trade, user: user)
      expect(account).to have_trade_award
    end
  end
end
