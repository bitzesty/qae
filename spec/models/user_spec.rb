require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { build(:user) }

  it 'creates a new account for user' do
    expect { user.save }.to change {
      Account.count
    }.by(1)

    account = Account.last
    expect(user.account).to eq(account)
    expect(user.owned_account).to eq(account)
    expect(account.owner).to eq(user)
  end
end
