require 'rails_helper'

describe FormAnswerDecorator do
  describe "#average_growth_for" do
    subject{ described_class.new form_answer }
    let(:form_answer) { build(:form_answer, sic_code: sic_code.code) }
    let(:year) { 1 }

    context "sic code present" do
      let(:sic_code) { SICCode.first }
      it "returns average growth for specific year" do
        expect(subject.average_growth_for(year)).to eq(sic_code.by_year(year))
      end
    end

    context "sic code not present" do
      let(:sic_code){ double(code: nil) }
      it "returns nil" do
        expect(subject.average_growth_for(year)).to be_nil
      end
    end
  end
end
