require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.build(:user) }

  it 'creates a new account for user' do
    expect { user.save }.to change {
      Account.count
    }.by(1)

    account = Account.last
    expect(user.account).to eq(account)
    expect(user.owned_account).to eq(account)
    expect(account.owner).to eq(user)
  end

  describe '#has_trade_award?' do
    let!(:innovation_award) { create(:form_answer, :innovation, user: user) }

    it 'returns false when there is no trade award' do
      expect(user).not_to have_trade_award
    end

    it 'returns true when there is a trade award' do
      create(:form_answer, :trade, user: user)
      expect(user).to have_trade_award
    end
  end
end
