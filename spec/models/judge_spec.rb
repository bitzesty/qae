require "rails_helper"

RSpec.describe Judge, type: :model do
  describe "#soft_delete!" do
    it "should set deleted to true" do
      judge = create(:judge)
      judge.soft_delete!
      expect(judge.reload).to be_deleted
    end
  end
end
