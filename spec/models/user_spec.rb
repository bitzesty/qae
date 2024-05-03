require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "creates a new account for user" do
    expect { user.save }.to change {
      Account.count
    }.by(1)

    account = Account.last
    expect(user.account).to eq(account)
    expect(user.owned_account).to eq(account)
    expect(account.owner).to eq(user)
  end

  describe "scopes" do
    it ".not_including should exclude id" do
      expect(User.where.not(id: 1).to_sql).to eq User.not_including(build_stubbed(:user, id: 1)).to_sql
    end

    it ".not_in_ids should exclude ids" do
      expect(User.where.not(id: [1, 2]).to_sql).to eq User.not_in_ids([1, 2]).to_sql
    end

    it ".confirmed should exclude ids" do
      expect(User.where.not(confirmed_at: nil).to_sql).to eq User.confirmed.to_sql
    end
  end

  describe "#new_member?" do
    it "should return true" do
      expect(User.new(created_at: 4.days.ago).new_member?).to be_falsey
    end
    it "should return false" do
      expect(User.new(created_at: 2.days.ago).new_member?).to be_truthy
    end
  end

  describe "#reset_password_period_valid?" do
    it "should return true" do
      expect(User.new(reset_password_sent_at: Date.new(2015, 4, 21), imported: true).reset_password_period_valid?).to be_truthy
    end
    it "should return false" do
      expect(User.new(reset_password_sent_at: Date.new(2014, 4, 21), imported: true).reset_password_period_valid?).to be_falsey
    end
  end
end
