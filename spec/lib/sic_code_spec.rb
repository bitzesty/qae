require "rails_helper"

describe SicCode do
  describe "regex" do
    let(:regex) { described_class::REGEX }

    it "matches the sic codes with correct format" do
      expect("1020").to match(regex)
      expect("1020/1").to match(regex)
      expect("1120/2").to match(regex)
    end

    it "does not match the wrong format codes" do
      expect("10201").to_not match(regex)
      expect("1020/12").to_not match(regex)
      expect("111/2").to_not match(regex)
      expect("111").to_not match(regex)
      expect("11111/1").to_not match(regex)
    end
  end

  describe "#by_year" do
    subject { SicCode.first }

    it "gets average growth by year" do
      expect(subject.by_year(1)).to eq(subject.year1)
    end
  end
end
