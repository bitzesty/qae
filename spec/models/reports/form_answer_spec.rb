require "rails_helper"

describe Reports::FormAnswer do
  describe "#employees" do
    it "returns number of employees" do
      obj = build(:form_answer, :trade)
      obj.document["employees_6of6"] = 10
      obj.document["trade_commercial_success"] = "6 plus"
      expect(described_class.new(obj).employees).to eq(10)
    end
  end
end
