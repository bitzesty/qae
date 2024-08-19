require "rails_helper"

RSpec.describe Comment, type: :model do
  subject { build(:comment) }

  it "has valid factory" do
    expect(subject).to be_valid
  end

  describe "scopes & class methods" do
    it ".flagged should filter correctly" do
      expect(Comment.where(flagged: true).order(created_at: :desc).to_sql).to eq Comment.flagged.to_sql
    end
  end
end
