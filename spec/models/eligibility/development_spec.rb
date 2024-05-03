require "rails_helper"

RSpec.describe Eligibility::Development, type: :model do
  let(:account) { FactoryBot.create(:account) }

  context "answers storage" do
    it "saves and reads answers" do
      eligibility = Eligibility::Development.new(account:)
      eligibility.sustainable_development = "yes"

      expect { eligibility.save! }.to change {
        Eligibility::Development.count
      }.by(1)

      eligibility = Eligibility::Development.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_sustainable_development
    end
  end

  describe "#eligible?" do
    let(:eligibility) { Eligibility::Development.new(account:) }

    it "is not eligible by default" do
      expect(eligibility).not_to be_eligible
    end

    it "is eligible when all questions are answered correctly" do
      eligibility.able_to_provide_actual_figures = "yes"
      eligibility.has_management_and_two_employees = "yes"
      eligibility.sustainable_development = "yes"
      eligibility.adheres_to_sustainable_principles = "yes"
      expect(eligibility).to be_eligible
    end

    it "is not eligible when not all answers are correct" do
      eligibility.sustainable_development = "no"

      expect(eligibility).not_to be_eligible
    end
  end

  describe ".award_name" do
    let(:eligibility) { Eligibility::Development.new(account:) }

    it "should return award_name" do
      expect(eligibility.class.award_name).to eq "Sustainable Development Award"
    end
  end
end
