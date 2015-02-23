require "rails_helper"

describe Ability do
  context "admin actions" do
    let(:user) { create :admin }
    let(:ability) { Ability.new(user) }

    it "returns true for permitted actions" do
      expect(ability.can?(:manage, :users)).to be true
    end

    it "returns false for unexisting resources" do
      expect(ability.can?(:manage, :cars)).to be false
    end

    it "returns true for reading if user can manage resource" do
      expect(ability.can?(:read, :users)).to be true
    end
  end

  context "admin actions" do
    let(:user) { create :admin, :lead_assessor }
    let(:ability) { Ability.new(user) }

    it "returns true for permitted actions" do
      expect(ability.can?(:create, :comments)).to be true
    end

    it "returns false for unexisting resources" do
      expect(ability.can?(:manage, :cars)).to be false
    end
  end
end
