require "rails_helper"

RSpec.describe Assessor, type: :model do
  describe "#lead?" do
    let(:form_answer) { build(:form_answer, :trade) }
    context "lead" do
      let(:assessor) { build(:assessor, :lead_for_trade) }
      it "is true" do
        expect(assessor.lead?(form_answer)).to eq(true)
      end
    end
    context "regular (not assigned)" do
      let(:assessor) { build(:assessor, :regular_for_trade) }
      it "is false" do
        expect(assessor.lead?(form_answer)).to eq(false)
      end
    end
  end
end
