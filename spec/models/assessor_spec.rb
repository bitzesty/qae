# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assessor, type: :model do
  describe "#create" do
    it "creates an autosave token for an assessor" do
      assessor = Assessor.create!(
        email: "john-assessor@example.com",
        first_name: "John",
        last_name: "Smith",
        password: "^#ur9EkLm@1W",
        password_confirmation: "^#ur9EkLm@1W"
      )

      expect(assessor.autosave_token).not_to be nil
    end
  end

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
