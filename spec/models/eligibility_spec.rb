require "rails_helper"

describe Eligibility do
  it { is_expected.to belong_to(:account).optional }
  it { is_expected.to belong_to(:form_answer).optional }

  describe "base validation" do
    it "should raise error" do
      object = Eligibility::Validation::Base.new(double, double, double)
      expect { object.valid? }.to raise_error(NotImplementedError)
    end
  end

  describe ".questions" do
    it "should return questions keys" do
      Eligibility.property(:test, {})
      expect(Eligibility.questions).to eq [:test]
    end
  end

  describe ".additional_label" do
    it "should return questions keys" do
      Eligibility.property(:test, { additional_label: "additional_labels" })
      expect(Eligibility.additional_label(:test)).to eq "additional_labels"
    end
  end

  describe "#sorted_answers" do
    it "should return sorted_answers" do
      Eligibility.property(:test, {})
      eligibility = Eligibility.new(answers: { test: "ans" })
      expect(eligibility.sorted_answers).to eq ({ "test" => "ans" })
    end
  end
end
