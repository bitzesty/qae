require 'spec_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.build(:user) }

  it 'creates a new account for user' do
    expect { user.save }.to change {
      Account.count
    }.by(1)

    expect(user.account_id).to eq(Account.last.id)
  end
end
