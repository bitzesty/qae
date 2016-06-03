require "rails_helper"

describe FormAnswerDecorator do

  let(:user) { build_stubbed(:user, first_name: "John", last_name: "Doe") }

  describe "#average_growth_for" do
    subject { described_class.new form_answer }
    let(:form_answer) { build(:form_answer, sic_code: sic_code.code) }
    let(:year) { 1 }

    context "sic code present" do
      let(:sic_code) { SICCode.first }
      it "returns average growth for specific year" do
        expect(subject.average_growth_for(year)).to eq(sic_code.by_year(year))
      end
    end

    context "sic code not present" do
      let(:sic_code) { double(code: nil) }
      it "returns nil" do
        expect(subject.average_growth_for(year)).to be_nil
      end
    end
  end

  describe "#last_state_updated_by" do
    it "Returns the person and time of who made the last transition" do

      Timecop.freeze(DateTime.new(2015, 2, 6, 8, 30)) do
        form_answer = create(:form_answer).decorate
        form_answer.state_machine.submit(form_answer.user)
        expect(form_answer.last_state_updated_by).to eq("Updated by John Doe -  6 Feb 2015 at 8:30am")
      end
    end
  end

  describe "#feedback_updated_by" do
    it "Returns the person and time of who made the feedback" do
      Timecop.freeze(DateTime.new(2015, 2, 6, 8, 30)) do
        form_answer = create(:feedback, authorable: user).form_answer.decorate
        expect(form_answer.feedback_updated_by).to eq("Updated by: John Doe -  6 Feb 2015 at 8:30am")
      end
    end
  end

  describe "#press_summary" do
    it "Returns the person and time of who made the last transition" do
      Timecop.freeze(DateTime.new(2015, 2, 6, 8, 30)) do
        form_answer = create(:press_summary, authorable: user).form_answer.decorate
        expect(form_answer.press_summary_updated_by).to eq("Updated by John Doe -  6 Feb 2015 at 8:30am")
      end
    end
  end
end
